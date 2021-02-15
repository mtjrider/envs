#!/usr/bin/env bash

DIR=$(dirname $0)
TARGET_OS=$1
CONDA=$2
CLEAR_CACHE=$3

SOURCE_CONDA="source ${CONDA}/etc/profile.d/conda.sh"
HOROVOD_FLAGS_MACOS="HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITH_GLOO=1"
HOROVOD_FLAGS_LINUX="HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_GPU=CUDA HOROVOD_GPU_OPERATIONS=NCCL"

create_dev_env() {
    if [[ ${CLEAR_CACHE} != "" ]]
    then
        if [[ ${CLEAR_CACHE} -gt 0 ]]
        then
            bash -c "${SOURCE_CONDA} && conda clean --all --yes"
        fi
    fi
    bash -c "${SOURCE_CONDA} && conda deactivate && conda env remove --name dev"
    if [[ ${TARGET_OS} = "macOS" ]]
    then    
        COMMAND="brew reinstall libuv"  # https://horovod.readthedocs.io/en/stable/install_include.html#gloo
        echo "${COMMAND}"
        bash -c "${COMMAND}"
        COMMAND="conda env create --name dev --file ${DIR}/conda/environments/dev-macos.yml"
        echo "${COMMAND}"
        bash -c "${SOURCE_CONDA} && ${COMMAND}"
        echo ""
        echo "installing additional pip dependencies"
        echo ""
        COMMAND="conda activate dev && \
            jupyter labextension install jupyterlab-nvdashboard && \
            pip install --no-cache-dir horovod[tensorflow,keras,pytorch]"
        echo "${HOROVOD_FLAGS_MACOS} ${COMMAND}"
        bash -c "${SOURCE_CONDA} && ${HOROVOD_FLAGS_MACOS} ${COMMAND}"
    elif [[ ${TARGET_OS} = "linux" ]]
    then
        COMMAND="conda env create --name dev --file ${DIR}/conda/environments/dev-linux.yml"
        echo "${COMMAND}"
        bash -c "${SOURCE_CONDA} && ${COMMAND}"
        echo ""
        echo "installing jupyter lab exentions and additional pip dependencies"
        echo ""
        COMMAND="conda activate dev && \
            jupyter labextension install jupyterlab-nvdashboard && \
            pip install --no-cache-dir git+https://github.com/horovod/horovod.git@v0.21.2"
        echo "${HOROVOD_FLAGS_LINUX} ${COMMAND}"
        bash -c "${SOURCE_CONDA} && ${HOROVOD_FLAGS_LINUX} ${COMMAND}"
    else
        echo "create_dev: invalid target os"
        echo "create_dev: target os must be either 'macOS' or 'linux'"
        exit 1
    fi
}

create_dev_env
