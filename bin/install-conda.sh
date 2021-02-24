#!/usr/bin/env bash

CONDA_LINUX=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
CONDA_MACOS=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

TARGET_OS=$1
PREFIX=$2
REINSTALL=$3

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

check_conda() {
    local PREFIX=$1
    local REINSTALL=$2
    if [[ -d "${PREFIX}/conda" ]]
    then
        echo ""
        echo "check_conda: detected conda"
        echo ""
        if [[ ${REINSTALL} != "" ]]
        then
            if [[ ${REINSTALL} -gt 0 ]]
            then
                COMMAND="rm -rf ${PREFIX}/conda"
                echo "check_conda: not using detected conda installation"
                echo "check_conda: executing conda installation"
                echo "check_conda: running '${COMMAND}'"
                echo ""
                bash -c "${COMMAND}"
            else
                echo "check_conda: using detected conda installation"
                echo "check_conda: skipping conda installation"
                echo ""
                exit 0
            fi
        else
            echo "check_conda: reinstallation flag not detected"
            echo "check_conda: using detected conda installation"
            echo "check_conda: skipping conda installation"
            echo ""
            exit 0        
        fi
    fi
}

install_conda() {
    check_os ${TARGET_OS} ${DETECTED_OS}
    check_conda ${PREFIX} ${REINSTALL}
    if [[ ${TARGET_OS} = "macOS" ]]
    then
        echo ${CONDA_MACOS}
        curl --insecure ${CONDA_MACOS} -o ${PREFIX}/miniconda.sh
        bash ${PREFIX}/miniconda.sh -b -p ${PREFIX}/conda && \
                ${PREFIX}/conda/bin/conda init && source ${PREFIX}/conda/etc/profile.d/conda.sh && \
                conda update --name base conda --yes && \
                rm -f ${PREFIX}/miniconda.sh
    elif [[ ${TARGET_OS} = "linux" ]]
    then
        echo ${CONDA_LINUX}
        curl --insecure ${CONDA_LINUX} -o ${PREFIX}/miniconda.sh
        bash ${PREFIX}/miniconda.sh -b -p ${PREFIX}/conda && \
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
