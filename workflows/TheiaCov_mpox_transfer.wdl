version 1.0

# compatible with thieaCov_PE_assembly PHB v2.3.0

# begin workflow
workflow theiacov_mpox_transfer {

    input {
        String sample_name
        String transfer_bucket_path
        
        # outputs from theiacov
        File aligned_bam
        File assembly_fasta
        File consensus_stats
        File ivar_tsv
        File ivar_vcf
        File kraken_report
        File kraken_report_dehosted
        File nextclade_json
        File nextclade_tsv
        File read1_dehosted
        File read2_dehosted

    }

    # secret variables
    String transfer_bucket = sub(transfer_bucket_path, "/$", "")

    call transfer{
        input:
            sample_name = sample_name, 
            transfer_bucket = transfer_bucket,

            aligned_bam = aligned_bam,
            assembly_fasta = assembly_fasta,
            consensus_stats = consensus_stats,
            ivar_tsv = ivar_tsv,
            ivar_vcf = ivar_vcf,
            kraken_report = kraken_report,
            kraken_report_dehosted = kraken_report_dehosted,
            nextclade_json = nextclade_json,
            nextclade_tsv = nextclade_tsv,
            read1_dehosted = read1_dehosted,
            read2_dehosted = read2_dehosted

    }


    output {
        
        String transfer_date=transfer.transfer_date
    }
}

task transfer{

    meta{
        description: "transfer output files from TheiaCov mpox module"
    }

    input{
        
        String sample_name
        String transfer_bucket
        
        # outputs from theiacov
        File aligned_bam
        File assembly_fasta
        File consensus_stats
        File ivar_tsv
        File ivar_vcf
        File kraken_report
        File kraken_report_dehosted
        File nextclade_json
        File nextclade_tsv
        File read1_dehosted
        File read2_dehosted

    }
    

    command <<<
        gsutil -m cp ~{aligned_bam} ~{transfer_bucket}/alignments/
        gsutil -m cp ~{assembly_fasta} ~{transfer_bucket}/assemblies/
        gsutil -m cp ~{consensus_stats} ~{transfer_bucket}/bam_stats/
        gsutil -m cp ~{ivar_tsv} ~{transfer_bucket}/ivar/
        gsutil -m cp ~{ivar_vcf} ~{transfer_bucket}/ivar/
        gsutil -m cp ~{kraken_report} ~{transfer_bucket}/kraken/
        gsutil -m cp ~{kraken_report_dehosted} ~{transfer_bucket}/kraken/
        gsutil -m cp ~{nextclade_json} ~{transfer_bucket}/nextclade/
        gsutil -m cp ~{nextclade_tsv} ~{transfer_bucket}/nextclade/
        gsutil -m cp ~{read1_dehosted} ~{transfer_bucket}/fastq_scrubbed/
        gsutil -m cp ~{read2_dehosted} ~{transfer_bucket}/fastq_scrubbed/

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