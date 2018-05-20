workflow build_training_dataset {
  File vcf_file
  File vcf_index
  File bed_file
  File bam_file
  File bam_idx
  File ctg_list
  File ref_file

  call trueset_vcf_processing {
    input: vcf_file = vcf_file, 
           vcf_index = vcf_index, 
           bed_file = bed_file
  }

  call get_trueset_tensor {
    input: vcf_trimmed = trueset_vcf_processing.vcf_trimmed,
           ref_file = ref_file,
           bam_file = bam_file,
           bam_idx = bam_idx,
           ctg_list = ctg_list 
  }

  call get_nonvariant_tensor {
    input: bed_file = bed_file,
           ref_file = ref_file,
           bam_file = bam_file,
           bam_idx = bam_idx,
           ctg_list = ctg_list 
  }

  call combine_tensors {
    input: can_tensor = get_nonvariant_tensor.tensor_out,
           var_tensor = get_trueset_tensor.tensor_out,
           bed_file = bed_file,
           var_file = get_trueset_tensor.var_all
  }
  
  output {
    File vcf_trimmed = trueset_vcf_processing.vcf_trimmed
    File var_all = get_trueset_tensor.var_all
    File tensor_var_out = get_trueset_tensor.tensor_out
    File tensor_can_out = get_nonvariant_tensor.tensor_out
    File combined_tensor_out = combine_tensors.tensor_out
  }
}



task trueset_vcf_processing {
  File vcf_file
  File vcf_index
  File bed_file

  command <<<

    gzip -dc ${vcf_file} | /opt/vcflib/bin/vcfbreakmulti | /opt/vcflib/bin/bgziptabix baseline.breakmulti.vcf.gz

    /opt/rtg-tools/rtg-tools-3.9-eda9a71/rtg vcffilter --include-bed=${bed_file}  -i baseline.breakmulti.vcf.gz -o baseline.breakmulti.inbed.vcf.gz

    gzip -dc baseline.breakmulti.inbed.vcf.gz | perl -ane 'if(/^#/){print}else{if(length($F[3])==1 && length($F[4])==1){print}elsif(length($F[3])==1 && length($F[4])<=5){print}elsif(length($F[3])<=5 && length($F[4])==1){print}}' | /opt/vcflib/bin/bgziptabix baseline.breakmulti.inbed.withOutSV.vcf.gz

    gzip -dc baseline.breakmulti.inbed.withOutSV.vcf.gz | perl -ane 'BEGIN{%a=();}{if(/^#/){print}elsif(not defined $a{"$F[0]-$F[1]"}){print;$a{"$F[0]-$F[1]"}=1;}}' | /opt/vcflib/bin/bgziptabix baseline.breakmulti.inbed.withOutSV.uniq.vcf.gz

    pigz -dc baseline.breakmulti.inbed.withOutSV.uniq.vcf.gz | perl -ane 'if(/^#/){print}else{@a=split ":",$F[-1];$a[0]=~s/\./0/;$a[0]=~s/\|/\//;@b=split "/",$a[0];if($b[0]>$b[1]){$a[0]="$b[1]/$b[0]"}else{$a[0]="$b[0]/$b[1]"};$F[-1]=join ":",@a; print join "\t", @F;print "\n";}' | /opt/vcflib/bin/bgziptabix baseline.breakmulti.inbed.withOutSV.uniq.normalizeGT.vcf.gz

  >>> 

  runtime {
    docker: "cschin/cv-worker"
  }

  output {
    File vcf_trimmed = "baseline.breakmulti.inbed.withOutSV.uniq.normalizeGT.vcf.gz"
  }
}



task get_trueset_tensor {

  File vcf_trimmed
  File ref_file
  File bam_file
  File bam_idx
  File ctg_list

  command <<<
    gunzip -dc ${ref_file} > ref.fa
    samtools faidx ref.fa

    for ctg in `cat ${ctg_list}`; do printf "pypy /opt/Clairvoyante/dataPrepScripts/GetTruth.py --vcf_fn ${vcf_trimmed} --var_fn var_$ctg --ctgName $ctg &\n"; done > run.sh

    echo "wait" >> run.sh; bash run.sh

    for ctg in `cat ${ctg_list}` ; do cat var_$ctg >> var_all; done

    for ctg in `cat ${ctg_list}`; do printf "pypy /opt/Clairvoyante/dataPrepScripts/CreateTensor.py --bam_fn ${bam_file} --can_fn var_$ctg --ctgName $ctg --ref_fn ref.fa --tensor_fn tensor_var_$ctg &\n"; done > run2.sh

    cat run2.sh

    echo "wait" >> run2.sh; sh run2.sh

    for ctg in `cat ${ctg_list}` ; do cat tensor_var_$ctg; done > tensor_var_all
  >>> 

  runtime {
    docker: "cschin/cv-worker"
    dx_instance_type: "mem3_ssd1_x32"
  }

  output {
    File tensor_out = "tensor_var_all"
    File var_all = "var_all"
  }
}

task get_nonvariant_tensor {

  File ref_file
  File bam_file
  File bam_idx
  File bed_file
  File ctg_list

  command <<<
    apt-get install -qqy parallel

    gunzip -dc ${ref_file} > ref.fa
    samtools faidx ref.fa

    for ctg in `cat ${ctg_list}`; do printf "pypy /opt/Clairvoyante/dataPrepScripts/ExtractVariantCandidates.py --bam_fn ${bam_file} --bed_fn ${bed_file} --ref_fn ref.fa --can_fn can_$ctg --ctgName $ctg --gen4Training --genomeSize 3000000000 --candidates 7000000 &\n"; done > run3.sh

    echo "wait">> run3.sh; sh run3.sh

    for ctg in `cat ${ctg_list}`; do printf "pypy /opt/Clairvoyante/dataPrepScripts/CreateTensor.py --bam_fn ${bam_file} --can_fn can_$ctg --ref_fn ref.fa --tensor_fn tensor_can_$ctg --ctgName $ctg \n"; done > run4.sh
 
    cat run4.sh | parallel -j 16

    wait
    
    for ctg in `cat ${ctg_list}`; do cat tensor_can_$ctg; done > tensor_can_all
  >>> 

  runtime {
    docker: "cschin/cv-worker"
    dx_instance_type: "mem3_ssd1_x32"
  }

  output {
    File tensor_out = "tensor_can_all"
  }
}

task docker_test {

  File ref_file

  command <<<

    echo $PWD
    
    ls

    gunzip -dc ${ref_file} > ref.fa
    samtools faidx ref.fa

  >>> 

  runtime {
    docker: "cschin/cv-worker"
  }

}

task get_trueset_sites {

  File vcf_trimmed
  File ctg_list

  command <<<
    for ctg in `cat ${ctg_list}`; do printf "pypy /opt/Clairvoyante/dataPrepScripts/GetTruth.py --vcf_fn ${vcf_trimmed} --var_fn var_$ctg --ctgName $ctg &\n"; done > run.sh 

    echo "wait" >> run.sh; bash run.sh

    for ctg in `cat ${ctg_list}` ; do cat var_$ctg >> var_all; done
   >>>

  runtime {
    docker: "cschin/cv-worker"
    dx_instance_type: "mem1_ssd1_x8"
  }

  output {
    File var_out = "var_all"
  }
}


task combine_tensors {

  File can_tensor
  File var_tensor
  File bed_file
  File var_file

  command <<<
    pypy /opt/Clairvoyante/dataPrepScripts/PairWithNonVariants.py \
    --tensor_can_fn ${can_tensor} \
    --tensor_var_fn ${var_tensor} \
    --bed_fn ${bed_file} \
    --output_fn tensor_can_var --amp 2

    python /opt/Clairvoyante/clairvoyante/tensor2Bin.py \
    --tensor_fn tensor_can_var \
    --var_fn ${var_file} \
    --bed_fn ${bed_file} \
    --bin_fn tensor_combined.bin
  >>> 

  runtime {
    docker: "cschin/cv-worker"
    dx_instance_type: "mem3_ssd1_x8"
  }

  output {
    File tensor_out = "tensor_combined.bin"
  }
}
