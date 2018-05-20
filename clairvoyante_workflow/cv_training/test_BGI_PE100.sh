WORKDIR=BGI-training-NA12878-hg37-PE100-results
dx run cv_training -i tensor_combine_bin=$WORKDIR/tensor_combined.bin --instance-type mem3_ssd1_gpu_x8 --destination WORKDIR/
