#!/bin/bash
sudo /anaconda2/bin/pip install intervaltree blosc --no-cache
sudo apt-get install -q samtools
wget -q https://bootstrap.pypa.io/get-pip.py
sudo -H pypy get-pip.py
sudo -H pypy -m pip install -q blosc --no-cache
sudo -H pypy -m pip install -q intervaltree --no-cache

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
export PYTHONPATH="/usr/share/dnanexus/lib/python2.7/site-packages:/usr/share/dnanexus/lib/python2.7/site-packages:/usr/share/dnanexus/lib/python2.7/site-packages:/usr/share/dnanexus/lib/python2.7/site-packages:"
source $HOME/environment
dx select clairvoyante_test
PROJECT=$(dx find projects --brief)
git clone --depth=1 https://github.com/aquaskyline/Clairvoyante.git
cd Clairvoyante 
dx download $PROJECT:/data/trainedModels.tbz
tar -jxf trainedModels.tbz

dx download $PROJECT:/data/training.tar.gz
tar -zxf training.tar.gz

dx download $PROJECT:/data/testingData.tar.gz
tar -zxf testingData.tar.gz

