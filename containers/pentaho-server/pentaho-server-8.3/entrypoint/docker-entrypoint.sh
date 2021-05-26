#!/bin/sh
 
export CATALINA_OPTS="$CATALINA_OPTS -DNODE_NAME=$(hostname)"

# Here we wil override all the files from the "/docker-entrypoint-init" into the pentaho base folder.
# This allows users to change configuration files before server starts

echo found $(find /docker-entrypoint-init/ -type f -print | wc -l) files to be copied
cp -r /docker-entrypoint-init/* /opt/pentaho/pentaho-server/

exec "$@"