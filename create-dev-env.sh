#!/usr/bin/env bash

TARGET_OS=$1
CC=$2
CXX=$3
CONDA=$4

source ${CONDA}/etc/profile.d/conda.sh

create_dev_env() {
    conda env remove --name dev
    if [[ ${TARGET_OS} = "macOS" ]]
    then
        COMMAND="CC=${CC} CXX=${CXX} conda env create --name dev --file conda/environments/dev-macos.yml"
        bash -c "echo ${COMMAND} && ${COMMAND}"
    elif [[ ${TARGET_OS} = "linux" ]]
    then
        COMMAND="CC=${CC} CXX=${CXX} conda env create --name dev --file conda/environments/dev-linux.yml"
        bash -c "echo ${COMMAND} && ${COMMAND}"
        conda activate dev && jupyter labextension install jupyterlab-nvdashboard
    else
        exit -1
    fi
}

create_dev_env
