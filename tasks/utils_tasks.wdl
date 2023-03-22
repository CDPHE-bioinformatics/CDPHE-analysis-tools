version 1.0

# begin tasks
kraken {
    meta {
        description: ""
    }

    input {
        String docker

    }

    command <<<

    >>>

    output{
        String kraken_docker = ~{docker}
        String kraken_version = 
    }

    runtime{

    }
}

NCBI_read_scrubber {
    meta {
        description: ""
    }

    input {
        String docker = "ncbi/sra-human-scrubber:2.0.0"
        File fastq_1
        File? fastq_2
        String read_type
        String sample_id

    }

    command <<<

    if [ ~{read_type} == 'paired' ]; then 

        # unzip fastq file
        gunzip -c ~{fastq_1} > ~{sample_id}_R1.fastq
        gunzip -c ~{fastq_2} > ~{sample_id}_R2.fastq

        # run scrubber
        scrub.sh -i ~{sample_id}_R1.fastq -o ~{sample_id}_R1_scrubbed.fastq |& tail -n1 | awk -F" " '{print $1}' > r1_spots_removed
        scrub.sh -i ~{sample_id}_R2.fastq -o ~{sample_id}_R2_scrubbed.fastq |& tail -n1 | awk -F" " '{print $1}' > r2_spots_removed

        # zip scrubbed fastq file
        gzip ~{sample_id}_R1_scrubbed.fastq
        gzip ~{sample_id}_R2_scrubbed.fastq

    elif [ ~{read_type} == 'single' ]; then 
        # unzip fastq file
        gunzip -c ~{fastq_1} > ~{sample_id}_R1.fastq

        # run scrubber
        scrub.sh -i ~{sample_id}_R1.fastq -o ~{sample_id}_R1_scrubbed.fastq |& tail -n1 | awk -F" " '{print $1}' > r1_spots_removed

        # zip scrubbed fastq file
        gzip ~{sample_id}_R1_scrubbed.fastq

    fi

    >>>

    output{
        String ncbi_sra_human_scrubber_docker = ~{docker}
        String read_string("r1_spots_removed")
        String? read_string("r2_spots_removed")
        File fastq_1_scrubbed = "~{sample_id}_R1_scrubbed.fastq.gz"
        File? fastq_2_scrubbed = "~{sample_id}_R2_scrubbed.fastq.gz"
    }

    runtime{
        docker: "~{docker}"
        memory: "8 GB"
        cpu: 4
        disks:  "local-disk " + disk_size + " SSD"
        disk: disk_size + " GB" # TES
        preemptible: 0
        maxRetries: 3

    }
}