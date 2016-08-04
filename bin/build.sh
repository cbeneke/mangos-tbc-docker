#!/usr/bin/env bash

# read full path of parent directory
DIR="$(dirname "$(readlink -f $(dirname "${BASH_SOURCE[0]}" ))" )"
DOCKER=${DIR}/docker/volumes/cmangos

MANGOS=eluna
MAKEPARAMS="-j5"

mkdir -p ${DIR}/build
mkdir -p ${DOCKER}

cd ${DIR}/build
cmake ../${MANGOS} -DCMAKE_INSTALL_PREFIX=${DOCKER}

make ${MAKEPARAMS}
make install
