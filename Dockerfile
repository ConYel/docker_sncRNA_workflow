#Use an official Ubuntu runtime as a parent image
FROM ubuntu:latest

#MAINTAINER ConYel <https://github.com/ConYel>

# Set the working directory to /home
WORKDIR /home

# Set shell for conda
SHELL ["/bin/bash", "-c"] 

#set User ROOT
USER root

# config problems about region and time 
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install libraries
RUN apt-get update -y \
	&& apt-get install -y --no-install-recommends \
	build-essential \
	software-properties-common \
	apt-utils \
	nano \
	dirmngr \
	bzip2 \
	cmake \
	default-jdk \
	git \
	libnss-sss \
	libtbb2 \
  libtbb-dev \
  ncurses-dev \
  tzdata \
  unzip \
  pigz \ 
  wget \
  gawk \
  zlib1g \
  zlib1g-dev \
  python3 \
  python3-pip \ 
  python-setuptools \ 
	r-base \   
	locales \
  && locale-gen en_US.UTF-8 \  
  && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
	&& bash ~/miniconda.sh -b -p ~/miniconda \
	&& rm ~/miniconda.sh \
	&& echo 'export PATH="~/miniconda/bin:$PATH"' >> ~/.bashrc \
	&& ln -sf ~/miniconda/condabin/conda /usr/local/bin/conda \
	&& rm -rf /var/lib/apt/lists/* /tmp/* 
  
# config conda channel
RUN conda update conda \
	&& conda config --add channels defaults \
	&& conda config --add channels bioconda \
	&& conda config --add channels conda-forge \
	&& conda install bedtools samtools star cutadapt multiqc fastqc sed -y
  
# fix an issue with libraries openssl
RUN ln -sf /root/miniconda/pkgs/openssl-1.1.1d-h7b6447c_4/lib/libcrypto.so.1.1 /usr/lib/libcrypto.so.1.0.0 \
	&& ln -sf /root/miniconda/pkgs/openssl-1.1.1d-h7b6447c_4/lib/libcrypto.so.1.1 /usr/lib/libcrypto.so.1.0.0
# install SPAR prepare
RUN git clone https://github.com/ConYel/spar_prepare.git \
&& chmod -R 700 spar_prepare/* 

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
