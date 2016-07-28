# cMaNGOS docker files

## building
build the cmangos files with

    ./bin/build.sh
  
and initialize the docker images with

    ./bin/init-docker.sh

After running this script, wait for the percona image to be fully initialized (check `docker logs mangos-percona` for the MySQL stating "[Note] mysqld: ready for connections."
You can then run

    docker stop mangos-percona

to stop (and delete) the temporary image. Your build should now be ready to go.  

## configuration
Extract the WoW Client data from the client and place it in the data folder. You can find further information for extracting on the cMaNGOS page (https://github.com/cmangos/issues/wiki/Installation-Instructions#extract-files-from-the-client).

Please set up your mangosd and realmd configurations in ./docker/volumes/cmangos/etc/ and rename the files from {{NAME}}.conf.dist to {{NAME}}.conf.

## running
You can start up the cMaNGOS stack with:

    cd docker
    docker-compose up -d

## FAQ
### ERROR: Database update needed
Please update missing database updates with

    docker run -it \
    --net={{DOCKER_NETWORK}} \
    -v ./cmangos/sql:/srv/sql \
    -v ./docker/volumes/percona/data:/var/lib/mysql \
    --link {{PERCONA_CONATINER_NAME}} \
    --rm percona /bin/bash

    mysql -u root -p -D {{DATABASE}} < /srv/sql/updates/{{UPDATE_SQL_FILE}}
    
replace the {{VARIABLES}} accordingly.
