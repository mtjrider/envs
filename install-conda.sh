#!/usr/bin/env bash

CONDA_LINUX=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
CONDA_MACOS=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

TARGET_OS=$1
PREFIX=$2

install_conda() {
    if [[ $TARGET_OS = "macOS" ]]
    then
	echo $CONDA_MACOS
	curl --insecure $CONDA_MACOS -o $PREFIX/miniconda.sh
	bash $PREFIX/miniconda.sh -b -p $PREFIX/conda && \
            $PREFIX/conda/bin/conda init && source $PREFIX/conda/etc/profile.d/conda.sh && \
            conda update --name base conda --yes && \
            rm -f $PREFIX/miniconda.sh	
    elif [[ $TARGET_OS = "linux" ]]
    then
	echo $CONDA_LINUX
	curl --insecure $CONDA_LINUX -o $PREFIX/miniconda.sh
	bash $PREFIX/miniconda.sh -b -p $PREFIX/conda && \
            $PREFIX/conda/bin/conda init && source $PREFIX/conda/etc/profile.d/conda.sh && \
            conda update --name base conda --yes && \
            rm -f $PREFIX/miniconda.sh	
    else
	    exit -1
    fi
}

if [[ $TARGET_OS = "macOS" ]]
then
    install_conda && \
	source ~/.bash_profile
elif [[ $TARGET_OS = "linux" ]]
then
    install_conda && \
    source ~/.bashrc
fi
