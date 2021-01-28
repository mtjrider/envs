#!/usr/bin/env bash

CC=$1
CXX=$2
CONDA=$3

source ${CONDA}/etc/profile.d/conda.sh

create_dev_env() {
    conda env remove --name dev
    CC=${CC} CXX=${CXX} conda env create --name dev --file conda/environments/dev.yml
    conda activate dev && jupyter labextension install jupyterlab-nvdashboard
}

create_dev_env
