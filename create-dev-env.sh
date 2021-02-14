#!/usr/bin/env bash

DIR=$(dirname $0)
TARGET_OS=$1
CONDA=$2
CLEAR_CACHE=$3

CONDA="${CONDA}/etc/profile.d/conda.sh"

create_dev_env() {
    if [[ ${CLEAR_CACHE} != "" ]]
    then
        conda clean --all --yes
    fi
    bash -c "source ${CONDA} && conda env remove --name dev"
    if [[ ${TARGET_OS} = "macOS" ]]
    then
        COMMAND="conda env create --name dev --file ${DIR}/conda/environments/dev-macos.yml"
        echo ${COMMAND}
        bash -c "source ${CONDA} && ${COMMAND}"
    elif [[ ${TARGET_OS} = "linux" ]]
    then
        COMMAND="conda env create --name dev --file ${DIR}/conda/environments/dev-linux.yml"
        echo "${QSIM_FLAGS} ${COMMAND}"
        bash -c "source ${CONDA} && ${QSIM_FLAGS} ${COMMAND}"
        echo ""
        echo "installing jupyter lab exentions and additional pip dependencies"
        echo ""
        HOROVOD_FLAGS="HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_GPU=CUDA HOROVOD_GPU_OPERATIONS=NCCL"
        COMMAND="conda activate dev && \
            jupyter labextension install jupyterlab-nvdashboard && \
            pip install --no-cache-dir horovod[tensorflow-gpu,keras,pytorch]"
        echo "${HOROVOD_FLAGS} ${COMMAND}"
        bash -c "source ${CONDA} && ${HOROVOD_FLAGS} ${COMMAND}"
    else
        echo "create_dev: invalid target os"
        echo "create_dev: target os must be either 'macOS' or 'linux'"
        exit 1
    fi
}

create_dev_env
