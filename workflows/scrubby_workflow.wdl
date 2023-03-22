version 1.0

import "../tasks/utils_tasks.wdl" as utils_tasks

# begin workflow
scrubby_workflow {
    input{

        String sample_id
        File fastq_1
        File? fastq_2
        String read_type
        String out_dir

  } 

    call utils_tasks.kraken as kraken_raw {

  }

    call utils_tasks.ncbi_read_scrubber as scrubber {

  }

    call utils_tasks.kraken as kraken_scrubbed {

  }

    call transfer {

  }

  output {
    
  }
}

# write unique transfer task here
# begin tasks
transfer {
    meta {
        description: ""
    }

    input {
        String sample_id
        String out_dir

    }

    String out_path = sub(out_dir, "/$", "") # fix if have a / at end

    command <<<

     # transfer date
        transferdate=`date`
        echo $transferdate | tee TRANSFERDATE

    >>>
    output {
        String transfer_date = read_string("TRANSFERDATE")
    }

    runtime {
        docker: "theiagen/utility:1.0"
        memory: "16 GiB"
        cpu: 4
        disks: "local-disk 50 SSD"
        preemptible: 0
    }
}


