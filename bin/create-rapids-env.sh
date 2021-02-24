#!/usr/bin/env bash

DIR=$(dirname $0)
CONDA=$1
CLEAR_CACHE=$2

SOURCE_CONDA="source ${CONDA}/etc/profile.d/conda.sh"
DETECTED_OS=$(echo $(uname) | tr '[:upper:]' '[:lower:]')

create_rapids_env() {
    if [[ ${CLEAR_CACHE} != "" ]]
    then
        if [[ ${CLEAR_CACHE} -gt 0 ]]
        then
            bash -c "${SOURCE_CONDA} && conda clean --all --yes"
        fi
    fi
    if [[ ${DETECTED_OS} = "linux" ]]
    then
        bash -c "${SOURCE_CONDA} && conda deactivate && conda env remove --name rapids"
        COMMAND="conda env create --name rapids --file ${DIR}/../conda-environments/rapids-linux.yml"
        echo "${COMMAND}"
        bash -c "${SOURCE_CONDA} && ${COMMAND}"
        echo ""
        echo "installing jupyter lab exentions and additional pip dependencies"
        echo ""
        COMMAND="conda activate rapids && \
            jupyter labextension install jupyterlab-nvdashboard"
        echo "${HOROVOD_FLAGS_LINUX} ${COMMAND}"
        bash -c "${SOURCE_CONDA} && ${COMMAND}"
    else
        echo "create_rapids_env: invalid os detected - ${DETECTED_OS}"
        echo "create_rapids_env: detected os must be 'Linux'"
        exit 1
    fi
}

create_rapids_env
