version 1.0

# begin tasks
transfer_kraken {
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

version 1.0

# begin tasks
transfer_scrubby {
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