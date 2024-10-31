# CDPHE-analysis-tools
*Next generation sequencing and bioinformatic and genomic analysis at CDPHE is not CLIA validated at this time. These workflows and their outputs are not to be used for diagnostic purposes and should only be used for public health action and surveillance purposes. CDPHE is not responsible for the incorrect or inappropriate use of these workflows or their results.

## Mpox transfer (TheiaCov_mpox_transfer.wdl)
This wdl workflow transfers the result files and intermediate files from the wf_theiacov_illumina_pe.wdl workflow to our bucket. Currently we use the XGen tiled amplicon primer scheme for WGS. We then perform genome assembly using [Theiagen Genomic's PHB wf_theiacov_illumina_pe.wdl](https://github.com/theiagen/public_health_bioinformatics/tree/main/workflows/theiacov) on the Terra platform. Following assembly we transfer the resutls and intermediate files to our GCP buckets using the TheaiCov_mpox_transfer.wdl.
### inputs

|Input Variable| description |
|:-------------:|:------------:|
| sample_name| column with the list of sample names (e.g. the entity:data_name_id)|
|transfer_bucket_path| user defined google bucket for where the files will be transferred to, string|
|aligned_bam| bam files |
|assembly_fasta| consensus fasteas|
|consesnus_stats||
|ivar_tsv| vcf file output from ivar|
|ivar_vcf| vcf file ouptut from ivar|
|kraken_report| kraken report output from kraken|
| kraken_report_dehosted|kraken report output from kraken|
|nextclade_json| nextclade json file output from nextclade|
|nextclade_tsv| nextclade file output from nextclade|
|read1_dehosted| scrubbed fastq file of human read data|
|read2_dehosted| scrubbed fastq file of human read data|

## Preprocess Illumina PE fastq data
This workflow takes in illumina PE fastq data. The workflow runs seqyclean on raw fastq files and then runs fastqc on raw and cleaned reads. Outputs from fastqc and seqyclean are transfered to the GCP bucket. 
