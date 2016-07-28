# cMaNGOS docker files

## docker-compose
You can start up the cMaNGOS stack with:

  cd docker
  docker-compose up -d

## cMaNGOS image
before starting the cMaNGOS stack, you must build the docker image with the init-docker.sh script
from the bin folder:

  cd bin
  ./init-docker.sh

## FAQ
### ERROR: Database update needed
Please update missing database updates with

  docker run -it \
  --net={{ docker network }} \
  -v ./cmangos/sql:/srv/sql \
  -v ./docker/volumes/percona/data:/var/lib/mysql \
  --link {{ percona container }} \
  --rm percona /bin/bash

  mysql -u root -p -D {{ database }} < /srv/sql/updates/{{ update-sql-file }}
