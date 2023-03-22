version 1.0

import "../tasks/utils_tasks.wdl" as utils_tasks
# begin workflow
kraken_workflow {
  input{

    String sample_id
    File fastq_1
    File? fastq_2
    String read_type
    String out_dir

  } 

  call utils_tasks.kraken as kraken {

  }

  output {

  }
}