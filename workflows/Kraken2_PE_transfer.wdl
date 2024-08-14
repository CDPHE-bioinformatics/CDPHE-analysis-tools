version 1.0

workflow Kraken2_PE_transfer {

    input {
        File kraken2_report
        File kraken2_classified_report
        File kraken2_classified_read1
        File kraken2_unclassified_read1
        File kraken2_classified_read2
        File kraken2_unclassified_read2
        String out_dir
    }

    call transfer_outputs {
        input:
            kraken2_report = kraken2_report,
            kraken2_classified_report = kraken2_classified_report,
            kraken2_classified_read1 = kraken2_classified_read1,
            kraken2_unclassified_read1 = kraken2_unclassified_read1,
            kraken2_classified_read1 = kraken2_classified_read2,
            kraken2_unclassified_read1 = kraken2_unclassified_read2,
            out_dir = out_dir
    }
    
    output {
        String transfer_date = transfer_outputs.transfer_date
    }
}    

task transfer_outputs {
    input {
        String out_dir
        File kraken2_report
        File kraken2_classified_report
        File kraken2_unclassified_read1
        File kraken2_classified_read1
        File kraken2_unclassified_read2
        File kraken2_classified_read2

    }

    String out_dir_path = sub(out_dir, "/$", "")

    command <<<
        
        gsutil -m cp ~{kraken2_report} ~{out_dir_path}/kraken2/
        gsutil -m cp ~{kraken2_classified_report} ~{out_dir_path}/kraken2/
        gsutil -m cp ~{kraken2_unclassified_read1} ~{out_dir_path}/kraken2/
        gsutil -m cp ~{kraken2_classified_read1} ~{out_dir_path}/kraken2/
        gsutil -m cp ~{kraken2_unclassified_read2} ~{out_dir_path}/kraken2/
        gsutil -m cp ~{kraken2_classified_read2} ~{out_dir_path}/kraken2/
        
        transferdate=`date`
        echo $transferdate | tee TRANSFERDATE
    >>>

    output {
        String transfer_date = read_string("TRANSFERDATE")
    }

    runtime {
        docker: "theiagen/utility:1.0"
        memory: "8 GB"
        cpu: 16
        disks: "local-disk 500 SSD"
    }
}