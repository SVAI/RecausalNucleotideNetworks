#!/bin/bash

main() {
    set -e -x -o pipefail
    /anaconda2/bin/pip install intervaltree blosc --no-cache
    apt-get install -qqy pypy wget
    wget -q https://bootstrap.pypa.io/get-pip.py
    pypy get-pip.py
    #pypy -m pip install -q blosc --no-cache
    pypy -m pip install -q intervaltree --no-cache
    dx-download-all-inputs
    export PATH=/anaconda2/bin/:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64/
    mkdir -p models
    python /opt/Clairvoyante/clairvoyante/train.py --v3 --bin_fn $HOME/in/tensor_combine_bin/${tensor_combine_bin_name} --ochk_prefix models/${model_prefix} 2>&1 | tee model_training.log
    tar czvf models.tar.gz models/
    mkdir -p $HOME/out/models
    mkdir -p $HOME/out/training_log
    mv models.tar.gz $HOME/out/models/
    mv model_training.log $HOME/out/training_log
    dx-upload-all-outputs
}
