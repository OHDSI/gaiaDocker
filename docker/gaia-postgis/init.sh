#!/bin/bash

echo gaia-db:$POSTGRES_PORT:$POSTGRES_DB:$POSTGRES_USER:$(cat $POSTGRES_PASSWORD_FILE) > ~/.pgpass
chmod 0600 ~/.pgpass
export POSTGRES_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)
export GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)
echo [gaia-postgis] api and postgis credentials set

exec "$@"