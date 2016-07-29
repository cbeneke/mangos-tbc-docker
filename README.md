# cMaNGOS docker files

Check out the submodules before anything.

## building
To enable access to the database update the ./cmangos/sql/create/db_create_mysql.sql file and 

        CREATE USER 'mangos'@'172.%' IDENTIFIED BY 'mangos';
        GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON `mangos`.* TO 'mangos'@'172.%';
        GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON `characters`.* TO 'mangos'@'172.%';
        GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON `realmd`.* TO 'mangos'@'172.%';

to expand the access rights to the 172.0.0.0/8 network (instead of 127.0.0.1) for the mangos user. Then build the cmangos files and initialize the docker image with

        ./bin/build.sh
        ./bin/init-docker.sh

After running this script, wait for the percona image to be fully initialized (check `docker logs mangos-percona` for the MySQL stating "[Note] mysqld: ready for connections."
You can then run

        docker stop mangos-percona

to stop (and delete) the temporary image. Your build should now be ready to go.  

## configuration
Extract the WoW Client data from the client and place it in the data folder. You can find further information for extracting on the cMaNGOS page (https://github.com/cmangos/issues/wiki/Installation-Instructions#extract-files-from-the-client).

Please set up your mangosd and realmd configurations in ./docker/volumes/cmangos/etc/ and rename the files from {{NAME}}.conf.dist to {{NAME}}.conf.

For a basic installation you only need to update the following settings:

mangosd.conf

        DataDir = "/opt/data"
        LogsDir = "/opt/logs"
        LoginDatabaseInfo     = "percona;3306;mangos;mangos;realmd"
        WorldDatabaseInfo     = "percona;3306;mangos;mangos;mangos"
        CharacterDatabaseInfo = "percona;3306;mangos;mangos;characters"

realmd.conf

        LoginDatabaseInfo = "percona;3306;mangos;mangos;realmd"
        LogsDir = "/opt/logs"

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

### How to upgrade?
After updating the cmangos submodule please rebuild the code with the

        ./bin/build.sh

and add possibly missing database updates as described above. Then restart the docker containers with

        cd docker
        docker-compose restart
