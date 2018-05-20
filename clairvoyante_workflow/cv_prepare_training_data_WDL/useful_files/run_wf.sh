VCF_FILE=/whole_genome_data/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_PGandRTGphasetransfer.vcf.gz
VCF_IDX=/whole_genome_data/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_PGandRTGphasetransfer.vcf.gz.tbi
BED_FILE=/whole_genome_data/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_nosomaticdel_noCENorHET7.bed
REF_FILE=/whole_genome_data/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz

# for smaller testing case
# BAM_FILE=/Ruibang_data/HG001.GRCh38_full_plus_hs38d1_analysis_set_minus_alt.50x.chr21-22.rg.bam
# BAM_IDX=/Ruibang_data/HG001.GRCh38_full_plus_hs38d1_analysis_set_minus_alt.50x.chr21-22.rg.bam.bai
# CTG_LIST=/hg38_ctg_21-22_list

# for whole genome (22 chromosomes)
BAM_FILE=/Ruibang_data/HG001.GRCh38_full_plus_hs38d1_analysis_set_minus_alt.50x.rg.bam
BAM_IDX=/Ruibang_data/HG001.GRCh38_full_plus_hs38d1_analysis_set_minus_alt.50x.rg.bam.bai
CTG_LIST=/hg38_ctg_list


OUTPUT_DIR=wdl_test_out
dx mkdir $OUTPUT_DIR 
dx run build_training_dataset -i stage-0.vcf_file=$VCF_FILE\
	                      -i stage-0.vcf_index=$VCF_IDX\
			      -i stage-0.bed_file=$BED_FILE\
			      -i stage-0.bam_file=$BAM_FILE\
			      -i stage-0.bam_idx=$BAM_IDX\
			      -i stage-0.ctg_list=$CTG_LIST\
			      -i stage-0.ref_file=$REF_FILE\
			      --destination $OUTPUT_DIR 
