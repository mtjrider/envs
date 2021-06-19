#!/usr/bin/env bash

DIR=$(dirname $0)
TARGET_OS=$1
CONDA=$2
CLEAR_CACHE=$3
CONDA_ENV_NAME=$4
CONDA_ENV_YML=$5

SOURCE_CONDA="source ${CONDA}/etc/profile.d/conda.sh"

HOROVOD_FLAGS_MACOS="HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITH_GLOO=1"

HOROVOD_BUILD_CUDA_CC_LIST=70,75,80
PYTORCH_HOROVOD_FLAGS_LINUX="HOROVOD_WITHOUT_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_GPU=CUDA HOROVOD_BUILD_CUDA_CC_LIST=${HOROVOD_BUILD_CUDA_CC_LIST} HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_NCCL_LINK=SHARED"
TENSORFLOW_HOROVOD_FLAGS_LINUX="HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITHOUT_PYTORCH=1 HOROVOD_GPU=CUDA HOROVOD_BUILD_CUDA_CC_LIST=${HOROVOD_BUILD_CUDA_CC_LIST} HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_NCCL_LINK=SHARED"
DEV_HOROVOD_FLAGS_LINUX="HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_GPU=CUDA HOROVOD_BUILD_CUDA_CC_LIST=${HOROVOD_BUILD_CUDA_CC_LIST} HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_NCCL_LINK=SHARED"

HOROVOD_GIT="https://github.com/horovod/horovod.git@v0.21.3"

create_env() {
    if [[ ${CLEAR_CACHE} != "" ]]
    then
        if [[ ${CLEAR_CACHE} -gt 0 ]]
        then
            bash -c "${SOURCE_CONDA} && conda clean --all --yes"
        fi
    fi
    if [[ ${TARGET_OS} = "macOS" ]]
    then
        bash -c "${SOURCE_CONDA} && conda deactivate && conda env remove --name dev"
        COMMAND="brew reinstall libuv"  # https://horovod.readthedocs.io/en/stable/install_include.html#gloo
        echo "${COMMAND}"
        bash -c "${COMMAND}"
        COMMAND="conda env create --name dev --file ${DIR}/../conda-environments/dev-macos.yml"
        echo "${COMMAND}"
        bash -c "${SOURCE_CONDA} && ${COMMAND}"
        echo ""
        echo "installing additional pip dependencies"
        echo ""
        COMMAND="conda activate dev && \
            jupyter labextension install jupyterlab-nvdashboard && \
            ${HOROVOD_FLAGS_MACOS} pip install --no-cache-dir git+${HOROVOD_GIT}"
        echo "${COMMAND}"
        bash -c "${SOURCE_CONDA} && ${HOROVOD_FLAGS_MACOS} ${COMMAND}"
    elif [[ ${TARGET_OS} = "linux" ]]
    then
        if [[ ${CONDA_ENV_NAME} = "pytorch" ]]
        then
            bash -c "${SOURCE_CONDA} && conda deactivate && conda env remove --name pytorch"
            CONDA_ENV_CREATE_COMMAND="conda env create --name pytorch --file ${DIR}/../conda-environments/pytorch-linux.yml"
            ADDITIONAL_PIP_COMMAND="conda activate pytorch && \
                ${PYTORCH_HOROVOD_FLAGS_LINUX} pip install --no-cache-dir git+${HOROVOD_GIT}"
        elif [[ ${CONDA_ENV_NAME} = "tensorflow" ]]
        then
            bash -c "${SOURCE_CONDA} && conda deactivate && conda env remove --name tensorflow"
            CONDA_ENV_CREATE_COMMAND="conda env create --name tensorflow --file ${DIR}/../conda-environments/tensorflow-linux.yml"
            ADDITIONAL_PIP_COMMAND="conda activate tensorflow && \
                ${TENSORFLOW_HOROVOD_FLAGS_LINUX} pip install --no-cache-dir git+${HOROVOD_GIT}"
        elif [[ ${CONDA_ENV_NAME} = "dev" ]]
        then
            bash -c "${SOURCE_CONDA} && conda deactivate && conda env remove --name dev"
            CONDA_ENV_CREATE_COMMAND="conda env create --name dev --file ${DIR}/../conda-environments/dev-linux.yml"
            ADDITIONAL_PIP_COMMAND="conda activate dev && \
                ${DEV_HOROVOD_FLAGS_LINUX} pip install --no-cache-dir git+${HOROVOD_GIT}"
        elif [[ ${CONDA_ENV_NAME} = "rapids" ]]
        then
            bash -c "${SOURCE_CONDA} && conda deactivate && conda env remove --name rapids"
            CONDA_ENV_CREATE_COMMAND="conda env create --name rapids --file ${DIR}/../conda-environments/rapids-linux.yml"
            ADDITIONAL_PIP_COMMAND="conda activate rapids && \
                echo 'none needed, skipping' "
        else
            echo "create_env: invalid environment name"
            echo "create_env: environment name must be one of 'pytorch', 'tensorflow', 'dev'"
            exit 1
        fi

        echo "${CONDA_ENV_CREATE_COMMAND}"
        bash -c "${SOURCE_CONDA} && ${CONDA_ENV_CREATE_COMMAND}"
        echo ""
        echo "installing additional jupyter lab exentions and pip dependencies (if necessary)"
        echo ""
        echo "${HOROVOD_FLAGS_LINUX} ${ADDITIONAL_PIP_COMMAND}"
        bash -c "${SOURCE_CONDA} && ${ADDITIONAL_PIP_COMMAND}" && echo "installation successful"
    else
        echo "create_env: invalid target os"
        echo "create_env: target os must be either 'macOS' or 'linux'"
        exit 1
    fi
}

create_env && ${SOURCE_CONDA}
