version 1.0

# Modified from Theiagen's Kraken2 workflow with dynamic disk and memory and only outputting Kraken report:
# https://github.com/theiagen/public_health_bioinformatics/blob/81b0e35fa0e74fee4a7079fc7e275182ef26bee9/workflows/standalone_modules/wf_kraken2_pe.wdl#L4

workflow kraken2_pe_minimal_wf {
  meta {
    description: "Classify paired-end reads using Kraken2"
  }
  input {
    String samplename
    File read1
    File read2
    File kraken2_db
  }
  call kraken2 as kraken2_pe {
    input:
      samplename = samplename,
      read1 = read1,
      read2 = read2,
      kraken2_db = kraken2_db
  }
  call krona {
    input:
      kraken2_report = kraken2_pe.kraken2_report,
      samplename = samplename
  }

  output {
    # Kraken2
    String kraken2_version = kraken2_pe.kraken2_version
    String kraken2_docker = kraken2_pe.kraken2_docker
    File kraken2_report = kraken2_pe.kraken2_report
    # Krona outputs
    String krona_version = krona.krona_version
    String krona_docker = krona.krona_docker
    File krona_html = krona.krona_html
  }
}

task kraken2 {
  input {
    File read1
    File? read2
    File kraken2_db
    String samplename
    String docker = "us-docker.pkg.dev/general-theiagen/staphb/kraken2:2.1.2-no-db"
    String kraken2_args = ""
    Int cpu = 4
  }

  Int disk_size = ceil(size(read1, "GB") + size(read2, "GB") + 2*size(kraken2_db, "GB")) + 20
  Int memory = ceil(2*size(kraken2_db, "GB"))

  command <<<
    echo $(kraken2 --version 2>&1) | sed 's/^.*Kraken version //;s/ .*$//' | tee VERSION
    date | tee DATE

    # Decompress the Kraken2 database
    mkdir db
    tar -C ./db/ -xzvf ~{kraken2_db}  

    # determine if paired-end or not
    if ! [ -z ~{read2} ]; then
      echo "Reads are paired..."
      mode="--paired"
    fi

    # determine if reads are compressed
    if [[ ~{read1} == *.gz ]]; then
      echo "Reads are compressed..."
      compressed="--gzip-compressed"
    fi

    # Run Kraken2
    echo "Running Kraken2..."
    kraken2 $mode $compressed \
        --db ./db/ \
        --threads ~{cpu} \
        --report ~{samplename}.report.txt \
        --output - \
        ~{kraken2_args} \
        ~{read1} ~{read2}
    
    # Report percentage of human reads
    percentage_human=$(grep "Homo sapiens" ~{samplename}.report.txt | cut -f 1)
    if [ -z "$percentage_human" ] ; then percentage_human="0" ; fi
    echo $percentage_human | tee PERCENT_HUMAN

  >>>
  output {
    String kraken2_version = read_string("VERSION")
    String kraken2_docker = docker
    String analysis_date = read_string("DATE")
    File kraken2_report = "~{samplename}.report.txt"
    Float kraken2_percent_human = read_float("PERCENT_HUMAN")
    String kraken2_database = kraken2_db
  }
  runtime {
      docker: "~{docker}"
      memory: "~{memory} GB"
      cpu: cpu
      disks: "local-disk " + disk_size + " SSD"
      preemptible: 0
  }
}

task krona {
  input {
    File kraken2_report
    String samplename
    String docker = "us-docker.pkg.dev/general-theiagen/staphb/krona:2.8.1"
    Int memory = 8
    Int cpu = 2
    Int disk_size = 100
  }
  command <<<
    # Get VERSION
    ktImportText | grep "KronaTools" | cut -d' ' -f3 | tee VERSION

    # run KrakenTools kreport2krona.py to enable viral compatibility
    kreport2krona.py -r ~{kraken2_report} -o ~{samplename}_krona.txt

    # Run krona with taxonomy on krakren report
    ktImportText ~{samplename}_krona.txt -o ~{samplename}_krona.html
  >>>
  output {
    String krona_version = read_string("VERSION")
    String krona_docker = docker
    File krona_html = "~{samplename}_krona.html"
  }
  runtime {
    docker: "~{docker}"
    memory: "~{memory} GB"
    cpu: cpu
    disks: "local-disk " + disk_size + " SSD"
    disk: disk_size + " GB"
    preemptible: 0
  }
}
