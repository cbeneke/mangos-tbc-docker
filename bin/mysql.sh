#!/usr/bin/env bash

NET=docker_default
DB=percona

docker run --net=$NET --link $DB -it percona /usr/bin/mysql -u root -p -h $DB
