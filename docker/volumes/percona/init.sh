#!/usr/bin/env bash

## init cmangos
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" < /srv/mangos/create/db_create_mysql.sql
for i in mangos realmd characters; do
    mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -D$i < /srv/mangos/base/$i.sql
done
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -Dmangos < /srv/mangos/scriptdev2/scriptdev2.sql

## init tbcdb
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -Dmangos < /srv/db/Current_Release/Full_DB/TBCDB_1.5.0_cmangos-tbc.sql

## init acid
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -Dmangos < /srv/acid/acid_tbc.sql
