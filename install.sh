#!/usr/bin/env bash

DIR="$(dirname "${BASH_SOURCE[0]}")"
DOCKER=${DIR}/docker/volumes/cmangos

mkdir -p ${DIR}/build
mkdir -p ${DOCKER}/bin

cd ${DIR}/build
cmake ../cmangos -DCMAKE_INSTALL_PREFIX=${DOCKER}/bin

make -j5
make install
