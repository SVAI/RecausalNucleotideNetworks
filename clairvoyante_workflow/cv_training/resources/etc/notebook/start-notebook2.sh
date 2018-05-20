#!/bin/bash

sudo /etc/notebook/install_anaconda2.sh

unset PYTHONPATH
export PATH=/anaconda3/bin/:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/
mkdir -p $HOME/notebooks/
cd $HOME/notebooks/
jupyter notebook --no-browser  --NotebookApp.token=''  --NotebookApp.disable_check_xsrf=True
