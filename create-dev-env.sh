#!/usr/bin/env bash

DIR=$(dirname $0)
TARGET_OS=$1
CC=$2
CXX=$3
CONDA=$4

create_dev_env() {
    conda deactivate
    conda clean --all --yes
    conda env remove --name dev
    if [[ ${TARGET_OS} = "macOS" ]]
    then
        COMMAND="CC=${CC} CXX=${CXX} conda env create --name dev --file ${DIR}/conda/environments/dev-macos.yml"
        echo ${COMMAND}
        ${COMMAND}
    elif [[ ${TARGET_OS} = "linux" ]]
    then
        COMMAND="CC=${CC} CXX=${CXX} conda env create --name dev --file ${DIR}/conda/environments/dev-linux.yml"
        echo ${COMMAND}
        ${COMMAND}
        echo ""
        echo "installing jupyter lab exentions and additional pip dependencies"
        echo ""
        COMMAND="conda activate dev && \
            jupyter labextension install jupyterlab-nvdashboard && \
            pip install --no-cache-dir git+https://github.com/horovod/horovod.git@v0.21.2"
        COMMAND="HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_GPU=CUDA HOROVOD_GPU_OPERATIONS=NCCL ${COMMAND}"
        echo ${COMMAND}
        ${COMMAND}
    else
        exit 1
    fi
}

source ${CONDA}/etc/profile.d/conda.sh && \
    create_dev_env
