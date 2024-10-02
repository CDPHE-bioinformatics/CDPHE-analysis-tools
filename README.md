# Utils
*Next generation sequencing and bioinformatic and genomic analysis at CDPHE is not CLIA validated at this time. These workflows and their outputs are not to be used for diagnostic purposes and should only be used for public health action and surveillance purposes. CDPHE is not responsible for the incorrect or inappropriate use of these workflows or their results.

## Scrubby Workflow


## Preprocess Illumina PE fastq data
This workflow takes in illumina PE fastq data. The workflow runs seqyclean on raw fastq files and then runs fastqc on raw and cleaned reads. Outputs from fastqc and seqyclean are transfered to the GCP bucket. 
