# cMaNGOS docker files

Check out the submodules before anything. Therefore choose between the .gitmodules.ssh and .gitmodules.http version and either link or copy the file to .gitmodules.

## building
To enable access to the database update the ./cmangos/sql/create/db_create_mysql.sql file and change 'localhost' to '172.%'. The last four lines should then look like this:

        CREATE USER 'mangos'@'172.%' IDENTIFIED BY 'mangos';
        GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON `mangos`.* TO 'mangos'@'172.%';
        GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON `characters`.* TO 'mangos'@'172.%';
        GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON `realmd`.* TO 'mangos'@'172.%';

This will expand the access rights to the 172.0.0.0/8 network (instead of 127.0.0.1) for the mangos user. Then build the cmangos files and initialize the docker image with

        ./bin/build.sh
        ./bin/init-docker.sh [ {{DATABASE_ROOT_PASSWORD}} ]

The password is optional. If none specified "mangos" will be used as password for the database user root. After running this script, wait for the percona image to be fully initialized (check `docker logs mangos-percona` for the MySQL stating "[Note] mysqld: ready for connections."
You can then run

        docker stop mangos-percona
        docker rm mangos-percona

to stop and delete the temporary image. Your build should now be ready to go.  

## configuration
Extract the WoW Client data from the client and place it in the data folder. You can find further information for extracting on the cMaNGOS page (https://github.com/cmangos/issues/wiki/Installation-Instructions#extract-files-from-the-client).

Please set up your mangosd and realmd configurations in ./docker/volumes/config/. Therefore copy the files from ./docker/volumes/cmangos/etc into respective ./docker/volumes/config/mangosd-{{NR}} and ./docker/volumes/config/realmd  and rename the files from {{NAME}}.conf.dist to {{NAME}}.conf. 

For a basic installation you can use the default files from the ./docker/volmes/config/ folder.

## running
You can start up the cMaNGOS stack with:

        cd docker
        docker-compose up -d

## FAQ
### ERROR: Database update needed
Please update missing database updates with

        docker run -it \
        --net={{DOCKER_NETWORK}} \
        -v {{PATH_TO_INSTALLATION}}/cmangos/sql:/srv/sql \
        -v {{PATH_TO_INSTALLATION}}/docker/volumes/percona/data:/var/lib/mysql \
        --link {{PERCONA_CONATINER_NAME}} \
        --rm percona /bin/bash

        mysql -u root -p -D {{DATABASE}} -h {{PERCONA_CONTAINER_NAME}} < /srv/sql/updates/{{UPDATE_SQL_FILE}}
    
replace the {{VARIABLES}} accordingly.

### How to upgrade?
After updating the cmangos submodule please rebuild the code with the

        ./bin/build.sh

and add possibly missing database updates as described above. Then restart the docker containers with

        cd docker
        docker-compose restart

### How can I access the mangos terminal?
Just attach to the running docker container with

        docker attach {{MANGOSD_CONTAINER_NAME}}

you can leave the interface with `CTRL+p CTRL+q`.

### How can I access the mysql cli?
Please use the `./bin/mysql.sh` binary to open a mysql cli for the percona docker image. If you use different docker names or a different network you have to edit the `NET` and `DB` variables. There will be a optional command line parameter to change these later.
