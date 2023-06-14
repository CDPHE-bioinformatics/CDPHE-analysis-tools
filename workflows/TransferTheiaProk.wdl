version 1.0

workflow TransferTheiaProk {

    input {
        Array[File?] read1_clean
        Array[File?] read2_clean
        Array[File?] assembly_fasta
        Array[File?] contigs_gfa
        Array[File?] contigs_fastg
        Array[File?] contigs_lastgraph
        Array[File?] quast_report
        Array[File?] cg_pipeline_report
        Array[File?] busco_report
        Array[File?] gambit_report
        Array[File?] gambit_closest_genomes
        Array[File?] ani_output_tsv
        Array[File?] amrfinderplus_all_report
        Array[File?] amrfinderplus_amr_report
        Array[File?] amrfinderplus_stress_report
        Array[File?] amrfinderplus_virulence_report
        Array[File?] resfinder_pheno_table
        Array[File?] resfinder_pheno_table_species
        Array[File?] resfinder_seqs
        Array[File?] resfinder_results
        Array[File?] resfinder_pointfinder_pheno_table
        Array[File?] resfinder_pointfinder_results
        Array[File?] ts_mlst_results
        Array[File?] prokka_gff
        Array[File?] prokka_gbk
        Array[File?] prokka_sqn
        Array[File?] plasmidfinder_results
        Array[File?] plasmidfinder_seqs
        Array[File?] kleborate_output_file
        Array[File?] legsta_results
        Array[File?] pbptyper_pbptype_predicted_tsv
        Array[File?] poppunk_gps_external_cluster_csv
        Array[File?] midas_report
        Array[File?] seroba_details
        Array[File?] kraken2_classified_read1
        Array[File?] kraken2_classified_read2
        Array[File?] kraken2_classified_report
        Array[File?] kraken2_report
        Array[File?] kraken2_unclassified_read1
        Array[File?] kraken2_unclassified_read2
        String out_dir
    }

    call transfer_outputs {
        input:
            read1_clean_not_empty = select_all(read1_clean),
            read2_clean_not_empty = select_all(read2_clean),
            assembly_fasta_not_empty = select_all(assembly_fasta),
            contigs_gfa_not_empty = select_all(contigs_gfa),
            contigs_fastg_not_empty = select_all(contigs_fastg),
            contigs_lastgraph_not_empty = select_all(contigs_lastgraph),
            quast_report_not_empty = select_all(quast_report),
            cg_pipeline_report_not_empty = select_all(cg_pipeline_report),
            busco_report_not_empty = select_all(busco_report),
            gambit_report_not_empty = select_all(gambit_report),
            gambit_closest_genomes_not_empty = select_all(gambit_closest_genomes),
            ani_output_tsv_not_empty = select_all(ani_output_tsv),
            amrfinderplus_all_report_not_empty = select_all(amrfinderplus_all_report),
            amrfinderplus_amr_report_not_empty = select_all(amrfinderplus_amr_report),
            amrfinderplus_stress_report_not_empty = select_all(amrfinderplus_stress_report),
            amrfinderplus_virulence_report_not_empty = select_all(amrfinderplus_virulence_report),
            resfinder_pheno_table_not_empty = select_all(resfinder_pheno_table),
            resfinder_pheno_table_species_not_empty = select_all(resfinder_pheno_table_species),
            resfinder_seqs_not_empty = select_all(resfinder_seqs),
            resfinder_results_not_empty = select_all(resfinder_results),
            resfinder_pointfinder_pheno_table_not_empty = select_all(resfinder_pointfinder_pheno_table),
            resfinder_pointfinder_results_not_empty = select_all(resfinder_pointfinder_results),
            ts_mlst_results_not_empty = select_all(ts_mlst_results),
            prokka_gff_not_empty = select_all(prokka_gff),
            prokka_gbk_not_empty = select_all(prokka_gbk),
            prokka_sqn_not_empty = select_all(prokka_sqn),
            plasmidfinder_results_not_empty = select_all(plasmidfinder_results),
            plasmidfinder_seqs_not_empty = select_all(plasmidfinder_seqs),
            kleborate_output_file_not_empty = select_all(kleborate_output_file),
            legsta_results_not_empty = select_all(legsta_results),
            pbptyper_pbptype_predicted_tsv_not_empty = select_all(pbptyper_pbptype_predicted_tsv),
            poppunk_gps_external_cluster_csv_not_empty = select_all(poppunk_gps_external_cluster_csv),
            seroba_details_not_empty = select_all(seroba_details),
            midas_report_not_empty = select_all(midas_report),
            kraken2_classified_read1_not_empty = select_all(kraken2_classified_read1),
        	kraken2_classified_read2_not_empty = select_all(kraken2_classified_read2),
        	kraken2_classified_report_not_empty = select_all(kraken2_classified_report),
        	kraken2_report_not_empty = select_all(kraken2_report),
        	kraken2_unclassified_read1_not_empty = select_all(kraken2_unclassified_read1),
        	kraken2_unclassified_read2_not_empty = select_all(kraken2_unclassified_read2),
            out_dir = out_dir
    }

    output {
        String transfer_date = transfer_outputs.transfer_date
    }
}

task transfer_outputs {
    input {
      Array[File] read1_clean_not_empty
      Array[File] read2_clean_not_empty
      Array[File] assembly_fasta_not_empty
      Array[File] contigs_gfa_not_empty
      Array[File] contigs_fastg_not_empty
      Array[File] contigs_lastgraph_not_empty
      Array[File] quast_report_not_empty
      Array[File] cg_pipeline_report_not_empty
      Array[File] busco_report_not_empty
      Array[File] gambit_report_not_empty
      Array[File] gambit_closest_genomes_not_empty
      Array[File] ani_output_tsv_not_empty
      Array[File] amrfinderplus_all_report_not_empty
      Array[File] amrfinderplus_amr_report_not_empty
      Array[File] amrfinderplus_stress_report_not_empty
      Array[File] amrfinderplus_virulence_report_not_empty
      Array[File] resfinder_pheno_table_not_empty
      Array[File] resfinder_pheno_table_species_not_empty
      Array[File] resfinder_seqs_not_empty
      Array[File] resfinder_results_not_empty
      Array[File] resfinder_pointfinder_pheno_table_not_empty
      Array[File] resfinder_pointfinder_results_not_empty
      Array[File] ts_mlst_results_not_empty
      Array[File] prokka_gff_not_empty
      Array[File] prokka_gbk_not_empty
      Array[File] prokka_sqn_not_empty
      Array[File] plasmidfinder_results_not_empty
      Array[File] plasmidfinder_seqs_not_empty
      Array[File] kleborate_output_file_not_empty
      Array[File] legsta_results_not_empty
      Array[File] pbptyper_pbptype_predicted_tsv_not_empty
      Array[File] poppunk_gps_external_cluster_csv_not_empty
      Array[File] seroba_details_not_empty
      Array[File] midas_report_not_empty
      Array[File] kraken2_classified_read1_not_empty
      Array[File] kraken2_classified_read2_not_empty
      Array[File] kraken2_classified_report_not_empty
      Array[File] kraken2_report_not_empty
      Array[File] kraken2_unclassified_read1_not_empty
      Array[File] kraken2_unclassified_read2_not_empty
      String out_dir
    }

    String outdirpath = sub(out_dir, "/$", "")

    command <<<

        gsutil -m cp ~{sep=' ' read1_clean_not_empty} ~{outdirpath}/filtered_reads/
        gsutil -m cp ~{sep=' ' read2_clean_not_empty} ~{outdirpath}/filtered_reads/
        gsutil -m cp ~{sep=' ' assembly_fasta_not_empty} ~{outdirpath}/assembly_and_assemtly_qc/
        gsutil -m cp ~{sep=' ' contigs_gfa_not_empty} ~{outdirpath}/assembly_and_assemtly_qc/
        gsutil -m cp ~{sep=' ' contigs_fastg_not_empty} ~{outdirpath}/assembly_and_assemtly_qc/
        gsutil -m cp ~{sep=' ' contigs_lastgraph_not_empty} ~{outdirpath}/assembly_and_assemtly_qc/
        gsutil -m cp ~{sep=' ' quast_report_not_empty} ~{outdirpath}/assembly_and_assemtly_qc/
        gsutil -m cp ~{sep=' ' cg_pipeline_report_not_empty} ~{outdirpath}/assembly_and_assemtly_qc/
        gsutil -m cp ~{sep=' ' busco_report_not_empty} ~{outdirpath}/assembly_and_assemtly_qc/
        gsutil -m cp ~{sep=' ' gambit_report_not_empty} ~{outdirpath}/taxon_id/
        gsutil -m cp ~{sep=' ' gambit_closest_genomes_not_empty} ~{outdirpath}/taxon_id/
        gsutil -m cp ~{sep=' ' ani_output_tsv_not_empty} ~{outdirpath}/ani-mummer/
        gsutil -m cp ~{sep=' ' amrfinderplus_all_report_not_empty} ~{outdirpath}/amrfinderplus/
        gsutil -m cp ~{sep=' ' amrfinderplus_amr_report_not_empty} ~{outdirpath}/amrfinderplus/
        gsutil -m cp ~{sep=' ' amrfinderplus_stress_report_not_empty} ~{outdirpath}/amrfinderplus/
        gsutil -m cp ~{sep=' ' amrfinderplus_virulence_report_not_empty} ~{outdirpath}/amrfinderplus/
        gsutil -m cp ~{sep=' ' resfinder_pheno_table_not_empty} ~{outdirpath}/resfinder/
        gsutil -m cp ~{sep=' ' resfinder_pheno_table_species_not_empty} ~{outdirpath}/resfinder/
        gsutil -m cp ~{sep=' ' resfinder_seqs_not_empty} ~{outdirpath}/resfinder/
        gsutil -m cp ~{sep=' ' resfinder_results_not_empty} ~{outdirpath}/resfinder/
        gsutil -m cp ~{sep=' ' resfinder_pointfinder_pheno_table_not_empty} ~{outdirpath}/resfinder/
        gsutil -m cp ~{sep=' ' resfinder_pointfinder_results_not_empty} ~{outdirpath}/resfinder/
        gsutil -m cp ~{sep=' ' ts_mlst_results_not_empty} ~{outdirpath}/mlst/
        gsutil -m cp ~{sep=' ' prokka_gff_not_empty} ~{outdirpath}/prokka/
        gsutil -m cp ~{sep=' ' prokka_gbk_not_empty} ~{outdirpath}/prokka/
        gsutil -m cp ~{sep=' ' prokka_sqn_not_empty} ~{outdirpath}/prokka/
        gsutil -m cp ~{sep=' ' plasmidfinder_results_not_empty} ~{outdirpath}/plasmidfinder/
        gsutil -m cp ~{sep=' ' plasmidfinder_seqs_not_empty} ~{outdirpath}/plasmidfinder/
        gsutil -m cp ~{sep=' ' kleborate_output_file_not_empty} ~{outdirpath}/kleborate/
        gsutil -m cp ~{sep=' ' legsta_results_not_empty} ~{outdirpath}/legsta/
        gsutil -m cp ~{sep=' ' pbptyper_pbptype_predicted_tsv_not_empty} ~{outdirpath}/merlin_magic/
        gsutil -m cp ~{sep=' ' poppunk_gps_external_cluster_csv_not_empty} ~{outdirpath}/merlin_magic/
        gsutil -m cp ~{sep=' ' seroba_details_not_empty} ~{outdirpath}/merlin_magic/
        gsutil -m cp ~{sep=' ' midas_report_not_empty} ~{outdirpath}/midas/
        gsutil -m cp ~{sep=' ' kraken2_classified_read1_not_empty} ~{outdirpath}/kraken2/
        gsutil -m cp ~{sep=' ' kraken2_classified_read2_not_empty} ~{outdirpath}/kraken2/
        gsutil -m cp ~{sep=' ' kraken2_classified_report_not_empty} ~{outdirpath}/kraken2/
        gsutil -m cp ~{sep=' ' kraken2_report_not_empty} ~{outdirpath}/kraken2/
        gsutil -m cp ~{sep=' ' kraken2_unclassified_read1_not_empty} ~{outdirpath}/kraken2/
        gsutil -m cp ~{sep=' ' kraken2_unclassified_read2_not_empty} ~{outdirpath}/kraken2/

        transferdate=`date`
        echo $transferdate | tee TRANSFERDATE
    >>>

    output {
        String transfer_date = read_string("TRANSFERDATE")
    }

    runtime {
        docker: "theiagen/utility:1.0"
        memory: "16 GB"
        cpu: 4
        disks: "local-disk 100 SSD"
    }
}
