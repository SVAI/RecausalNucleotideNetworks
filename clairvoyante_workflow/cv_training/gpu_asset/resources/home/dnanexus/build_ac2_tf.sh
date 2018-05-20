#!/bin/bash
pushd /tmp
sudo dpkg -i /tmp/libcudnn7_7.1.3.16-1+cuda9.0_amd64.deb
wget -q https://repo.continuum.io/archive/Anaconda2-5.1.0-Linux-x86_64.sh
bash Anaconda2-5.1.0-Linux-x86_64.sh -b -p /anaconda2

unset PYTHONPATH
export PATH=/anaconda2/bin/:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/

pip install --upgrade tensorflow-gpu==1.8.0
popd
