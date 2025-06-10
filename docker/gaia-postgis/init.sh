#!/bin/bash

echo gaia-db:$POSTGRES_PORT:$POSTGRES_DB:$POSTGRES_USER:$(cat $POSTGRES_PASSWORD_FILE) > ~/.pgpass
chmod 0600 ~/.pgpass
export GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)

tcpserver 0.0.0.0 $GAIA_POSTGIS_API_PORT ./api.sh