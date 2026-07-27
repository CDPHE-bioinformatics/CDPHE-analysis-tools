version 1.0

workflow run_hostile {
    input {
        File fastq1
        File? fastq2
        String seq_method
        Array[File] genome_index
        
        # Runtime resource configurations
        Int? cpu
        Int? mem_gb
        Int? disk_space_gb
    }

    call hostile {
        input:
            fastq1 = fastq1,
            fastq2 = fastq2,
            seq_method = seq_method,
            genome_index = genome_index,
            cpu = cpu,
            mem_gb = mem_gb,
            disk_space_gb = disk_space_gb
    }

    output {
        File fastq1_scrubbed = hostile.fastq1_scrubbed
        File? fastq2_scrubbed = hostile.fastq2_scrubbed
        File log_json = hostile.log_json
        String human_reads_removed = hostile.human_reads_removed
        String human_reads_removed_proportion = hostile.human_reads_removed_proportion
    }
}

task hostile {
    input {
        File fastq1
        File? fastq2
        String seq_method
        Array[File] genome_index

        # Default resources optimized for Bowtie2/Minimap2
        Int cpu = select_first([cpu, 4])
        Int mem_gb = select_first([mem_gb, 16])
        Int disk_space_gb = select_first([disk_space_gb, 100])
    }

    # Pinning requested staphb container version
    String docker = "staphb/hostile:2.0.2"

    String base_name = basename(basename(basename(fastq1, ".gz"), ".fastq"), ".fq")
    String fastq1_scrubbed_name = base_name + "_scrubbed.fastq.gz"
    String fastq2_scrubbed_name = sub(fastq1_scrubbed_name, "1(?=_scrubbed)", "2")

    command <<<
        set -eo pipefail

        # Log environmental info
        date | tee DATE
        hostile --version | tee VERSION

        # Localize optional paired-end file safely inside bash
        FASTQ2_PARAM=""
        if [ -n "~{fastq2}" ]; then
            FASTQ2_PARAM="--fastq2 ~{fastq2}"
        fi

        # Execute hostile clean based on sequencing technology
        if [[ "~{seq_method}" == "OXFORD_NANOPORE" ]]; then
            hostile clean \
                --fastq1 ~{fastq1} \
                --aligner "minimap2" \
                --threads ~{cpu} \
                --index ~{genome_index[0]} \
                > decontamination-log.json
            
            # Rename output single-end reads
            mv ./*.clean.fastq.gz "~{fastq1_scrubbed_name}"
        else
            # Strip index extension for Bowtie2 compatibility
            INDEX_PATH="~{sub(genome_index[0], '(\\.[0-9]\\.bt2|\\.rev\\.[0-9]\\.bt2)$', '')}"
            
            hostile clean \
                --fastq1 ~{fastq1} \
                ${FASTQ2_PARAM} \
                --aligner "bowtie2" \
                --threads ~{cpu} \
                --index "${INDEX_PATH}" \
                > decontamination-log.json
            
            # Rename primary clean outputs
            mv ./*.clean_1.fastq.gz "~{fastq1_scrubbed_name}"
            
            # Conditionally rename second read if it was provided
            if [ -n "~{fastq2}" ]; then
                mv ./*.clean_2.fastq.gz "~{fastq2_scrubbed_name}"
            fi
        fi

        # Metrics extraction for Terra data table propagation
        grep '"reads_removed":' ./decontamination-log.json | awk -F': ' '{print $2}' | awk -F',' '{print $1}' > HUMANREADS
        grep '"reads_removed_proportion":' ./decontamination-log.json | awk -F': ' '{print $2}' | awk -F',' '{print $1}' > HUMANREADS_PROP
    >>>

    output {
        File fastq1_scrubbed = "~{fastq1_scrubbed_name}"
        File? fastq2_scrubbed = if defined(fastq2) then "~{fastq2_scrubbed_name}" else None
        File log_json = "decontamination-log.json"
        String human_reads_removed = read_string("HUMANREADS")
        String human_reads_removed_proportion = read_string("HUMANREADS_PROP")
    }

    runtime {
        docker: docker
        memory: "~{mem_gb} GB"
        cpu: cpu
        disks: "local-disk " + disk_space_gb + " SSD"
        disk: disk_space_gb + " GB"
        preemptible: 1
        maxRetries: 3
    }
}
