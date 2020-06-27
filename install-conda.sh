#!/usr/bin/env bash

CONDA_LINUX=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
CONDA_MACOS=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

TARGET_OS=$1
PREFIX=$2

install_conda() {
    if [[ $TARGET_OS = "macOS" ]]
    then
	echo $CONDA_MACOS
	curl $CONDA_MACOS -o $2/miniconda.sh
    elif [[ $TARGET_OS = "linux" ]]
    then
	echo $CONDA_LINUX
	curl $CONDA_LINUX -o $2/miniconda.sh
    else
	exit -1
    fi

    bash $PREFIX/miniconda.sh -b -p $PREFIX/conda && \
        $PREFIX/conda/bin/conda init && source ~/.bashrc && \
        conda update --name base conda --yes && \
        rm -f $PREFIX/miniconda.sh
}

install_conda $@ && \
    source ~/.bashrc
