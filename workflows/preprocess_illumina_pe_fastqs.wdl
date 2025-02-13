version 1.0

workflow preprocess_illumina_pe_fastqs {

    input{
        String sample_name
        File fastq_1
        File fastq_2
        String transfer_path
    }



    call fastqc as fastqc_raw {
        
        input:
            fastq_1 = fastq_1,
            fastq_2 = fastq_2


    }

    call fastp {
        input:
        fastq_1 = fastq_1,
        fastq_2 = fastq_2,
        sample_name = sample_name

    }

    call fastqc as fastqc_cleaned {
        input:
            fastq_1 = fastp.fastq_1_cleaned,
            fastq_2 = fastp.fastq_2_cleaned

    }

    call transfer {
        input:
        sample_name = sample_name,
        transfer_path = transfer_path,

        fastqc1_html_raw = fastqc_raw.fastqc1_html,
        fastqc1_zip_raw = fastqc_raw.fastqc1_zip,
        fastqc2_html_raw = fastqc_raw.fastqc2_html,
        fastqc2_zip_raw = fastqc_raw.fastqc2_zip,

        fastq_1_cleaned = fastp.fastq_1_cleaned,
        fastq_2_cleaned = fastp.fastq_2_cleaned,
        fastq_1_unpaired = fastp.fastq_1_unpaired,
        fastq_2_unpaired = fastp.fastq_2_unpaired,
        fastp_html = fastp.fastp_html,
        fastp_json = fastp.fastp_json,

        fastqc1_html_cleaned = fastqc_cleaned.fastqc1_html,
        fastqc1_zip_cleaned = fastqc_cleaned.fastqc1_zip,
        fastqc2_html_cleaned = fastqc_cleaned.fastqc2_html,
        fastqc2_zip_cleaned = fastqc_cleaned.fastqc2_zip

    }

    output {

         # output from preprocess
        File fastqc1_html_raw = fastqc_raw.fastqc1_html
        File fastqc1_zip_raw = fastqc_raw.fastqc1_zip
        File fastqc2_html_raw = fastqc_raw.fastqc2_html
        File fastqc2_zip_raw = fastqc_raw.fastqc2_zip

        File fastq_1_cleaned = fastp.fastq_1_cleaned
        File fastq_2_cleaned = fastp.fastq_2_cleaned
        File fastq_1_unpaired = fastp.fastq_1_unpaired
        File fastq_2_unpaired = fastp.fastq_2_unpaired
        File fastp_html = fastp.fastp_html
        File fastp_json = fastp.fastp_json


        File fastqc1_html_cleaned = fastqc_cleaned.fastqc1_html
        File fastqc1_zip_cleaned = fastqc_cleaned.fastqc1_zip
        File fastqc2_html_cleaned = fastqc_cleaned.fastqc2_html
        File fastqc2_zip_cleaned = fastqc_cleaned.fastqc2_zip

        # versions
        String version_fastqc = fastqc_raw.version
        String version_fastp = fastp.version 
    }

}


task fastqc {

    input {

        File fastq_1
        File fastq_2
    }

    String fastq_1_basename = basename(fastq_1, ".fastq.gz")
    String fastq_2_basename = basename(fastq_2, ".fastq.gz")
    String docker = 'staphb/fastqc:0.11.9'

    command <<<

    fastqc --version | tee VERSION

    # run fastqc
    fastqc --outdir $PWD ~{fastq_1} ~{fastq_2}

    >>>

    output {
        File fastqc1_html = "~{fastq_1_basename}_fastqc.html"
        File fastqc1_zip = "~{fastq_1_basename}_fastqc.zip"
        File fastqc2_html = "~{fastq_2_basename}_fastqc.html"
        File fastqc2_zip = "~{fastq_2_basename}_fastqc.zip"
        String version = read_string("VERSION")
    }

    runtime{
        docker: docker
        memory: "2 GiB"
        cpu: 2
        disks: "local-disk 100 SSD"
        preemptible: 0
        maxRetries: 3

    }


}

task fastp {
    input {
        File fastq_1
        File fastq_2
        String sample_name
    }

    String docker = "staphb/fastp:0.23.2"

    command <<<

    fastp --version | tee VERSION

    fastp \
    --in1 ~{fastq_1} \
    --in2 ~{fastq_2} \
    --out1 ~{sample_name}_1P.fastq.gz \
    --out2 ~{sample_name}_2P.fastq.gz \
    --unpaired1 ~{sample_name}_1U.fastq.gz \
    --unpaired2 ~{sample_name}_2U.fastq.gz \
    --cut_tail \
    --cut_tail_window_size 4 \
    --cut_tail_mean_quality 30 \
    --length_required 70 \
    --detect_adapter_for_pe \
    --trim_poly_g \
    --html ~{sample_name}_fastp.html \
    --json ~{sample_name}_fastp.json

    >>>

    output{
        File fastq_1_cleaned = "~{sample_name}_1P.fastq.gz"
        File fastq_2_cleaned = "~{sample_name}_2P.fastq.gz"
        File fastq_1_unpaired = "~{sample_name}_1U.fastq.gz"
        File fastq_2_unpaired = "~{sample_name}_.2U.fastq.gz"
        File fastp_html = "~{sample_name}_fastp.html"
        File fastp_json = "~{sample_name}_fastp.json"
        String version = read_string("VERSION")
    }

    runtime {
        docker: docker
        memory: "8 GiB"
        cpu: 4
        disks: "local-disk 100 SSD"
        preemptible: 0
        maxRetries: 3
  }
}


task transfer{
    input{
        String sample_name
        String transfer_path

        File fastqc1_html_raw
        File fastqc1_zip_raw
        File fastqc2_html_raw
        File fastqc2_zip_raw
        
        File fastq_1_cleaned
        File fastq_2_cleaned
        File fastq_1_unpaired
        File fastq_2_unpaired
        File fastp_html
        File fastp_json

        File fastqc1_html_cleaned 
        File fastqc1_zip_cleaned 
        File fastqc2_html_cleaned
        File fastqc2_zip_cleaned 

    }

    String transfer_path_2 =  sub(transfer_path, "/$", "") # fix if have a / at end

    String docker = "theiagen/utility:1.0"

    command <<<

     # transfer fastqc raw
        gsutil -m cp ~{fastqc1_html_raw} ~{transfer_path_2}/fastqc_raw/
        gsutil -m cp ~{fastqc1_zip_raw} ~{transfer_path_2}/fastqc_raw/
        gsutil -m cp ~{fastqc2_html_raw} ~{transfer_path_2}/fastqc_raw/
        gsutil -m cp ~{fastqc2_zip_raw} ~{transfer_path_2}/fastqc_raw/

        # transfter fastp
        gsutil -m cp ~{fastq_1_cleaned} ~{transfer_path_2}/fastp/
        gsutil -m cp ~{fastq_2_cleaned} ~{transfer_path_2}/fastp/
        gsutil -m cp ~{fastq_1_unpaired} ~{transfer_path_2}/fastp/
        gsutil -m cp ~{fastq_2_unpaired} ~{transfer_path_2}/fastp/
        gsutil -m cp ~{fastp_html} ~{transfer_path_2}/fastp/
        gsutil -m cp ~{fastp_json} ~{transfer_path_2}/fastp/


        # transfer fastqc clean
        gsutil -m cp ~{fastqc1_html_cleaned} ~{transfer_path_2}/fastqc_cleaned/
        gsutil -m cp ~{fastqc1_zip_cleaned} ~{transfer_path_2}/fastqc_cleaned/
        gsutil -m cp ~{fastqc2_html_cleaned} ~{transfer_path_2}/fastqc_cleaned/
        gsutil -m cp ~{fastqc2_zip_cleaned} ~{transfer_path_2}/fastqc_cleaned/

        # transfer date
        transferdate=`date`
        echo $transferdate | tee TRANSFERDATE


    >>>
    output{
        String transfer_date = read_string("TRANSFERDATE")


    }
    runtime{
        docker: docker
        memory: "16 GiB"
        cpu: 4
        disks: "local-disk 50 SSD"
        preemptible: 0

    }


}
