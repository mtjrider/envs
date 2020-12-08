#!/usr/bin/env bash

CC=$1
CXX=$2

create_dev_env() {
    conda env remove --name dev
    CC=${CC} CXX=${CXX} conda env create --name dev --file conda/environments/dev.yml
}

create_dev_env $@
