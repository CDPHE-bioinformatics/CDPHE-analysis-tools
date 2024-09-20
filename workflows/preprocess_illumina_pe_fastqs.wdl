version 1.0

workflow preprocess_illumina_pe_fastqs {

    input{
        String sample_name
        File fastq_1
        File fastq_2
        File contam_fasta
        String transfer_path
    }



    call fastqc as fastqc_raw {
        
        input:
            fastq_1 = fastq_1,
            fastq_2 = fastq_2


    }

    call seqyclean {
        input:
            contam_fasta = contam_fasta,
            sample_name = sample_name,
            fastq_1 = fastq_1,
            fastq_2 = fastq_2


    }

    call fastqc as fastqc_cleaned {
        input:
            fastq_1 = seqyclean.fastq_1_cleaned,
            fastq_2 = seqyclean.fastq_2_cleaned

    }

    call transfer {
        input:
        sample_name = sample_name,
        transfer_path = transfer_path,

        fastqc1_html_raw = fastqc_raw.fastqc1_html,
        fastqc1_zip_raw = fastqc_raw.fastqc1_zip,
        fastqc2_html_raw = fastqc_raw.fastqc2_html,
        fastqc2_zip_raw = fastqc_raw.fastqc2_zip,

        seqyclean_summary = seqyclean.seqyclean_summary,

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

        File seqyclean_summary = seqyclean.seqyclean_summary

        File fastqc1_html_cleaned = fastqc_cleaned.fastqc1_html
        File fastqc1_zip_cleaned = fastqc_cleaned.fastqc1_zip
        File fastqc2_html_cleaned = fastqc_cleaned.fastqc2_html
        File fastqc2_zip_cleaned = fastqc_cleaned.fastqc2_zip


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

    fastqc --version | tee version

    # run fastqc
    fastqc --outdir $PWD ~{fastq_1} ~{fastq_2}

    >>>

    output {
        File fastqc1_html = "~{fastq_1_basename}_fastqc.html"
        File fastqc1_zip = "~{fastq_1_basename}_fastqc.zip"
        File fastqc2_html = "~{fastq_2_basename}_fastqc.html"
        File fastqc2_zip = "~{fastq_2_basename}_fastqc.zip"
        String fastqc_version = read_string("VERSION")
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

task seqyclean {

    input {
        File contam_fasta
        String sample_name
        File fastq_1
        File fastq_2

    }

    String docker = "staphb/seqyclean:1.10.09"

    command <<<

    # pull version out of the summary file
    awk 'NR==2 {print $1}' ~{sample_name}_clean_SummaryStatistics.tsv | tee VERSION

    seqyclean -minlen 70 -qual 30 30 -gz -1 ~{fastq_1} -2 ~{fastq_2} -c ~{contam_fasta} -o ~{sample_name}_clean

    >>>
    output {
        String seqyclean_version = read_string("VERSION")
        File fastq_1_cleaned = "${sample_name}_clean_PE1.fastq.gz"
        File fastq_2_cleaned = "${sample_name}_clean_PE2.fastq.gz"
        File seqyclean_summary = "${sample_name}_clean_SummaryStatistics.tsv"


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

task transfer{
    input{
        String sample_name
        String transfer_path

        File fastqc1_html_raw
        File fastqc1_zip_raw
        File fastqc2_html_raw
        File fastqc2_zip_raw

        File seqyclean_summary 

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

        # transfter seqyclean
        gsutil -m cp ~{seqyclean_summary} ~{transfer_path_2}/seqyclean/

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
