#!/usr/bin/env bash

CONDA_LINUX=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
CONDA_MACOS=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

TARGET_OS=$1
PREFIX=$2

DETECTED_OS=$(echo $(uname) | tr '[:upper:]' '[:lower:]')

check_os() {
    local TARGET_OS=$1
    local DETECTED_OS=$2
    TARGET_OS=$(echo "${TARGET_OS}" | tr '[:upper:]' '[:lower:]')
    if [[ ${TARGET_OS} = "macos" ]]
    then
        TARGET_OS="darwin"
    fi
    if [[ ${TARGET_OS} != ${DETECTED_OS} ]]
    then
        echo "check_os: invalid target os"
        echo "check_os: target os (${TARGET_OS}) does not match detected os (${DETECTED_OS})"
	    exit 1
    fi
}

install_conda() {
    check_os ${TARGET_OS} ${DETECTED_OS}
    if [[ ${TARGET_OS} = "macOS" ]]
    then
        echo ${CONDA_MACOS}
        curl --insecure ${CONDA_MACOS} -o ${PREFIX}/miniconda.sh
        bash ${PREFIX}/miniconda.sh -b -u -p ${PREFIX}/conda && \
                ${PREFIX}/conda/bin/conda init && source ${PREFIX}/conda/etc/profile.d/conda.sh && \
                conda update --name base conda --yes && \
                rm -f ${PREFIX}/miniconda.sh
    elif [[ ${TARGET_OS} = "linux" ]]
    then
        echo ${CONDA_LINUX}
        curl --insecure ${CONDA_LINUX} -o ${PREFIX}/miniconda.sh
        bash ${PREFIX}/miniconda.sh -b -u -p ${PREFIX}/conda && \
                ${PREFIX}/conda/bin/conda init && source ${PREFIX}/conda/etc/profile.d/conda.sh && \
                conda update --name base conda --yes && \
                rm -f ${PREFIX}/miniconda.sh	
    else
        echo "install_conda: invalid target os"
        echo "install_conda: target os must be either 'macOS' or 'linux'"
	    exit 1
    fi
}

if [[ ${TARGET_OS} = "macOS" ]]
then
    install_conda && \
	source ~/.bash_profile
elif [[ ${TARGET_OS} = "linux" ]]
then
    install_conda && \
    source ~/.bashrc
fi
