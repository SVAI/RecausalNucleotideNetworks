FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -qq -y ant default-jdk tabix pigz parallel git unzip build-essential
WORKDIR /opt/
RUN git clone https://github.com/RealTimeGenomics/rtg-tools.git &&\
    cd rtg-tools/ && ant zip-nojre &&\
    unzip -o dist/rtg-tools-3.9-eda9a71-nojre.zip
RUN apt-get install -qq -y zlib1g-dev libbz2-dev liblzma-dev
RUN git clone --recursive https://github.com/vcflib/vcflib &&\
    cd vcflib/ &&\
    make
RUN apt-get install -q -y samtools pypy python-pip
RUN pip install intervaltree blosc
RUN apt-get install -q -y wget
RUN wget -q https://bootstrap.pypa.io/get-pip.py
RUN pypy get-pip.py
#RUN pypy -m pip install -q blosc --no-cache
RUN pypy -m pip install -q intervaltree --no-cache
RUN apt-get install -qqy python-numpy
RUN python -m pip install --upgrade pip
RUN pip install --upgrade tensorflow
RUN git clone --depth=1 https://github.com/aquaskyline/Clairvoyante.git
