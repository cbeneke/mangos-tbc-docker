#!/usr/bin/env bash

if [ $# -eq 1 ]; then
    MYSQL_PWD=$1
else
    MYSQL_PWD=mangos
fi

# read full path of parent directory
DIR="$(dirname "$(readlink -f $(dirname "${BASH_SOURCE[0]}" ))" )"
DOCKER=${DIR}/docker

CMANGOSSQL=${DIR}/cmangos/sql
ACIDSQL=${DIR}/acid
DBSQL=${DIR}/tbcdb


for image in $(ls ${DOCKER}/images); do
    docker build -t ${image} ${DOCKER}/images/${image}
done

docker run \
    --name mangos-percona \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_PWD} \
    -v ${DOCKER}/volumes/percona/data:/var/lib/mysql \
    -v ${CMANGOSSQL}:/srv/mangos \
    -v ${ACIDSQL}:/srv/acid \
    -v ${DBSQL}:/srv/db \
    -v ${DOCKER}/volumes/percona/init.sh:/docker-entrypoint-initdb.d/init.sh \
    -d percona:latest
echo "Please stop mangos-percona image after initialization"
