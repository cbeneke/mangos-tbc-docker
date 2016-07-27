#!/usr/bin/env bash

# read full path of parent directory
DIR="$(dirname "$(readlink -f $(dirname "${BASH_SOURCE[0]}" ))" )"
DOCKER=${DIR}/docker/volumes/cmangos

mkdir -p ${DIR}/build
mkdir -p ${DOCKER}

cd ${DIR}/build
cmake ../cmangos -DCMAKE_INSTALL_PREFIX=${DOCKER}

make -j5
make install
