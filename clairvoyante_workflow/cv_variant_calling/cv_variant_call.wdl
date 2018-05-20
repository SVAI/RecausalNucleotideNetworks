task cv_variant_call {

  File model_tar_ball

  File ref_file
  File bam_file
  File bam_idx
  String sample_name
  String model_prefix

  command <<<
    sudo apt-update
    sudo apt-get install -qqy parallel
    gunzip -dc ${ref_file} > ref.fa
    samtools faidx ref.fa

    tar zxvf ${model_tar_ball}
    mkdir -p out_vcf
    python /opt/Clairvoyante/clairvoyante/callVarBamParallel.py \
       	   --chkpnt_fn models/${model_prefix} \
	   --ref_fn ref.fa \
	   --bam_fn ${bam_file} \
	   --sampleName ${sample_name} \
	   --output_prefix out_vcf/cv_out \
	   --tensorflowThreads 24 \
	   --threshold 0.1 \
           --minCoverage 4 \
	   --refChunkSize 10000000  > run_all.sh
    cat run_all.sh | parallel -j 24
    tar czvf cv_vcf_files.tgz out_vcf/
  >>> 

  runtime {
    docker: "cschin/cv-worker"
    dx_instance_type: "mem3_ssd1_x32"
  }

  output {
    File vcf_tar_ball = "cv_vcf_files.tgz"
  }
}
