version 1.0

workflow TransferPhoenix {

    input {
        Array[File?] full_results
        Array[File?] griphin_excel_summary
        Array[File?] griphin_tsv_summary
        Array[File?] raw_read1_html
        Array[File?] raw_read1_zip
        Array[File?] raw_read2_html
        Array[File?] raw_read2_zip
        Array[File?] kraken_trimd_output 
        Array[File?] kraken_trimd_summary
        Array[File?] kraken_trimd_top_taxa
        Array[File?] trimd_html
        Array[File?] trimd_krona
        Array[File?] classified_1
        Array[File?] unclassified_1
        Array[File?] classified_2
        Array[File?] unclassified_2
        Array[File?] paired_fastp_html
        Array[File?] paired_fastp_json
        Array[File?] single_fastp_html
        Array[File?] single_fastp_json
        Array[File?] trimmed_singles
        Array[File?] trimmed_read1
        Array[File?] trimmed_read2
        Array[File?] trimmed_read_counts
        Array[File?] adapter_removal_log
        Array[File?] assembly_graph
        Array[File?] filtered_scaffolds_log
        Array[File?] contigs
        Array[File?] filtered_scaffolds
        Array[File?] assembly_with_seq_names
        Array[File?] assembly
        Array[File?] spades_log
        Array[File?] kraken_wtasmbld_output 
        Array[File?] kraken_wtasmbld_summary
        Array[File?] kraken_wtasmbld_top_taxa
        Array[File?] wtasmbld_html
        Array[File?] wtasmbld_krona
        Array[File?] fast_ani
        Array[File?] reformated_fast_ani
        Array[File?] top_20_taxa_matches
        Array[File?] mash_distance
        Array[File?] quast_summary
        Array[File?] mlst_tsv
        Array[File?] srst2
        Array[File?] gamma_ar_calls
        Array[File?] blat_ar_calls
        Array[File?] gamma_hv_calls
        Array[File?] blat_hv_calls
        Array[File?] gamma_pf_calls
        Array[File?] blat_pf_calls
        Array[File?] assembly_ratio_file
        Array[File?] gc_content_file
        Array[File?] summary_line
        Array[File?] synopsis
        Array[File?] best_taxa_id
        Array[File?] amrfinder_mutations
        Array[File?] amrfinder_taxa_match
        Array[File?] amrfinder_hits
        Array[File?] versions_file
        Array[File?] multiqc_output
        String out_dir
    }

    call transfer_outputs {
        input:
            full_results_not_empty = select_all(full_results),
            griphin_excel_summary_not_empty = select_all(griphin_excel_summary),
            griphin_tsv_summary_not_empty = select_all(griphin_tsv_summary),
            raw_read1_html_not_empty = select_all(raw_read1_html),
            raw_read1_zip_not_empty = select_all(raw_read1_zip),
            raw_read2_html_not_empty = select_all(raw_read2_html),
            raw_read2_zip_not_empty = select_all(raw_read2_zip),
            kraken_trimd_output_not_empty = select_all(kraken_trimd_output), 
            kraken_trimd_summary_not_empty = select_all(kraken_trimd_summary),
            kraken_trimd_top_taxa_not_empty = select_all(kraken_trimd_top_taxa),
            trimd_html_not_empty = select_all(trimd_html),
            trimd_krona_not_empty = select_all(trimd_krona),
            classified_1_not_empty = select_all(classified_1),
            unclassified_1_not_empty = select_all(unclassified_1),
            classified_2_not_empty = select_all(classified_2),
            unclassified_2_not_empty = select_all(unclassified_2),
            paired_fastp_html_not_empty = select_all(paired_fastp_html),
            paired_fastp_json_not_empty = select_all(paired_fastp_json),
            single_fastp_html_not_empty = select_all(single_fastp_html),
            single_fastp_json_not_empty = select_all(single_fastp_json),
            trimmed_singles_not_empty = select_all(trimmed_singles),
            trimmed_read1_not_empty = select_all(trimmed_read1),
            trimmed_read2_not_empty = select_all(trimmed_read2),
            trimmed_read_counts_not_empty = select_all(trimmed_read_counts),
            adapter_removal_log_not_empty = select_all(adapter_removal_log),
            assembly_graph_not_empty = select_all(assembly_graph),
            filtered_scaffolds_log_not_empty = select_all(filtered_scaffolds_log),
            contigs_not_empty = select_all(contigs),
            filtered_scaffolds_not_empty = select_all(filtered_scaffolds),
            assembly_with_seq_names_not_empty = select_all(assembly_with_seq_names),
            assembly_not_empty = select_all(assembly),
            spades_log_not_empty = select_all(spades_log),
            kraken_wtasmbld_output_not_empty = select_all(kraken_wtasmbld_output),
            kraken_wtasmbld_summary_not_empty = select_all(kraken_wtasmbld_summary),
            kraken_wtasmbld_top_taxa_not_empty = select_all(kraken_wtasmbld_top_taxa),
            wtasmbld_html_not_empty = select_all(wtasmbld_html),
            wtasmbld_krona_not_empty = select_all(wtasmbld_krona),
            fast_ani_not_empty = select_all(fast_ani),
            reformated_fast_ani_not_empty = select_all(reformated_fast_ani),
            top_20_taxa_matches_not_empty = select_all(top_20_taxa_matches),
            mash_distance_not_empty = select_all(mash_distance),
            quast_summary_not_empty = select_all(quast_summary),
            mlst_tsv_not_empty = select_all(mlst_tsv),
            srst2_not_empty = select_all(srst2),
            gamma_ar_calls_not_empty = select_all(gamma_ar_calls),
            blat_ar_calls_not_empty = select_all(blat_ar_calls),
            gamma_hv_calls_not_empty = select_all(gamma_hv_calls),
            blat_hv_calls_not_empty = select_all(blat_hv_calls),
            gamma_pf_calls_not_empty = select_all(gamma_pf_calls),
            blat_pf_calls_not_empty = select_all(blat_pf_calls),
            assembly_ratio_file_not_empty = select_all(assembly_ratio_file),
            gc_content_file_not_empty = select_all(gc_content_file),
            summary_line_not_empty = select_all(summary_line),
            synopsis_not_empty = select_all(synopsis),
            best_taxa_id_not_empty = select_all(best_taxa_id),
            amrfinder_mutations_not_empty = select_all(amrfinder_mutations),
            amrfinder_taxa_match_not_empty = select_all(amrfinder_taxa_match),
            amrfinder_hits_not_empty = select_all(amrfinder_hits),
            versions_file_not_empty = select_all(versions_file),
            multiqc_output_not_empty = select_all(multiqc_output),
            out_dir = out_dir
    }

    output {
        String transfer_date = transfer_outputs.transfer_date
    }
}

task transfer_outputs {
    input {
        Array[File] full_results_not_empty
        Array[File] griphin_excel_summary_not_empty
        Array[File] griphin_tsv_summary_not_empty
        Array[File] raw_read1_html_not_empty
        Array[File] raw_read1_zip_not_empty
        Array[File] raw_read2_html_not_empty
        Array[File] raw_read2_zip_not_empty
        Array[File] kraken_trimd_output_not_empty
        Array[File] kraken_trimd_summary_not_empty
        Array[File] kraken_trimd_top_taxa_not_empty
        Array[File] trimd_html_not_empty
        Array[File] trimd_krona_not_empty
        Array[File] classified_1_not_empty
        Array[File] unclassified_1_not_empty
        Array[File] classified_2_not_empty
        Array[File] unclassified_2_not_empty
        Array[File] paired_fastp_html_not_empty
        Array[File] paired_fastp_json_not_empty
        Array[File] single_fastp_html_not_empty
        Array[File] single_fastp_json_not_empty
        Array[File] trimmed_singles_not_empty
        Array[File] trimmed_read1_not_empty
        Array[File] trimmed_read2_not_empty
        Array[File] trimmed_read_counts_not_empty
        Array[File] adapter_removal_log_not_empty
        Array[File] assembly_graph_not_empty
        Array[File] filtered_scaffolds_log_not_empty
        Array[File] contigs_not_empty
        Array[File] filtered_scaffolds_not_empty
        Array[File] assembly_with_seq_names_not_empty
        Array[File] assembly_not_empty
        Array[File] spades_log_not_empty
        Array[File] kraken_wtasmbld_output_not_empty 
        Array[File] kraken_wtasmbld_summary_not_empty
        Array[File] kraken_wtasmbld_top_taxa_not_empty
        Array[File] wtasmbld_html_not_empty
        Array[File] wtasmbld_krona_not_empty
        Array[File] fast_ani_not_empty
        Array[File] reformated_fast_ani_not_empty
        Array[File] top_20_taxa_matches_not_empty
        Array[File] mash_distance_not_empty
        Array[File] quast_summary_not_empty
        Array[File] mlst_tsv_not_empty
        Array[File] srst2_not_empty
        Array[File] gamma_ar_calls_not_empty
        Array[File] blat_ar_calls_not_empty
        Array[File] gamma_hv_calls_not_empty
        Array[File] blat_hv_calls_not_empty
        Array[File] gamma_pf_calls_not_empty
        Array[File] blat_pf_calls_not_empty
        Array[File] assembly_ratio_file_not_empty
        Array[File] gc_content_file_not_empty
        Array[File] summary_line_not_empty
        Array[File] synopsis_not_empty
        Array[File] best_taxa_id_not_empty
        Array[File] amrfinder_mutations_not_empty
        Array[File] amrfinder_taxa_match_not_empty
        Array[File] amrfinder_hits_not_empty
        Array[File] versions_file_not_empty
        Array[File] multiqc_output_not_empty
        String out_dir
    }

     String outdirpath = sub(out_dir, "/$", "")

     command <<<

        gsutil -m cp ~{sep=' ' full_results_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' griphin_excel_summary_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' griphin_tsv_summary_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' raw_read1_html_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' raw_read1_zip_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' raw_read2_html_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' raw_read2_zip_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' kraken_trimd_output_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' kraken_trimd_summary_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' kraken_trimd_top_taxa_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' trimd_html_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' trimd_krona_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' classified_1_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' unclassified_1_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' classified_2_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' unclassified_2_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' paired_fastp_html_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' paired_fastp_json_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' single_fastp_html_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' single_fastp_json_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' trimmed_singles_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' trimmed_read1_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' trimmed_read2_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' trimmed_read_counts_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' adapter_removal_log_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' assembly_graph_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' filtered_scaffolds_log_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' contigs_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' filtered_scaffolds_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' assembly_with_seq_names_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' assembly_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' spades_log_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' kraken_wtasmbld_output_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' kraken_wtasmbld_summary_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' kraken_wtasmbld_top_taxa_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' wtasmbld_html_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' wtasmbld_krona_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' fast_ani_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' reformated_fast_ani_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' top_20_taxa_matches_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' mash_distance_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' quast_summary_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' mlst_tsv_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' srst2_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' gamma_ar_calls_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' blat_ar_calls_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' gamma_hv_calls_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' blat_hv_calls_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' gamma_pf_calls_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' blat_pf_calls_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' assembly_ratio_file_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' gc_content_file_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' summary_line_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' synopsis_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' best_taxa_id_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' amrfinder_mutations_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' amrfinder_taxa_match_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' amrfinder_hits_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' versions_file_not_empty} ~{outdirpath}/phoenix/
        gsutil -m cp ~{sep=' ' multiqc_output_not_empty} ~{outdirpath}/phoenix/

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