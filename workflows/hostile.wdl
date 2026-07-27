version 1.0

workflow run_hostile {
  input {
    File fastq1
    File? fastq2
    String seq_method
    Array[File] genome_index
  }

  call hostile {
    input:
      fastq1 = fastq1,
      fastq2 = fastq2,
      seq_method = seq_method,
      genome_index = genome_index
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
  }

  String docker = "staphb/hostile:2.0.2"
  Int disk_size = 100
  Int cpu = 4
  Int mem = 16

  String base_name = basename(basename(basename(fastq1, ".gz"), ".fastq"), ".fq")
  String fastq1_scrubbed_name = base_name + "_scrubbed.fastq.gz"
  String fastq2_scrubbed_name = sub(fastq1_scrubbed_name, "1(?=_scrubbed)", "2")

  command <<<
    # date and version control
    date | tee DATE
    hostile --version | tee VERSION

    # dehost reads based on sequencing method
    if [[ "~{seq_method}" == "OXFORD_NANOPORE" ]]; then
      hostile clean \
        --fastq1 ~{fastq1} \
        --aligner "minimap2" \
        --threads ~{cpu} \
        --index ~{genome_index[0]} \
      | tee decontamination-log.json
      # rename scrubbed fastq
      mv ./*.clean.fastq.gz "~{fastq1_scrubbed_name}"
    else
      hostile clean \
        --fastq1 ~{fastq1} \
        --fastq2 ~{fastq2} \
        --aligner "bowtie2" \
        --threads ~{cpu} \
        --index ~{sub(genome_index[0], ".1.bt2", "")} \
      | tee decontamination-log.json
      # rename scrubbed fastqs
      mv ./*.clean_1.fastq.gz "~{fastq1_scrubbed_name}"
      
      # Only attempt to move read 2 if it actually exists to prevent non-zero exit codes
      if [ -f ./*.clean_2.fastq.gz ]; then
        mv ./*.clean_2.fastq.gz "~{fastq2_scrubbed_name}"
      fi
    fi

    # extract the number of removed human reads
    grep '"reads_removed":' ./decontamination-log.json | awk -F': ' '{print $2}' | awk -F',' '{print $1}' > HUMANREADS
    grep '"reads_removed_proportion":' ./decontamination-log.json | awk -F': ' '{print $2}' | awk -F',' '{print $1}' > HUMANREADS_PROP
  >>>

  output {
    File fastq1_scrubbed = "${fastq1_scrubbed_name}"
    File? fastq2_scrubbed = "${fastq2_scrubbed_name}"
    File log_json = "decontamination-log.json"
    String human_reads_removed = read_string("HUMANREADS")
    String human_reads_removed_proportion = read_string("HUMANREADS_PROP")
    String hostile_docker = docker
  }

  runtime {
    docker: docker
    memory: "~{mem} GB"
    cpu: cpu
    disks: "local-disk " + disk_size + " SSD"
    disk: disk_size + " GB"
    preemptible: 0
    maxRetries: 3
  }
}
