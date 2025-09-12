#!/bin/bash

echo gaia-db:$POSTGRES_PORT:$POSTGRES_DB:$POSTGRES_USER:$(cat $POSTGRES_PASSWORD_FILE) > ~/.pgpass
chmod 0600 ~/.pgpass
export PGPASSWORD=$(cat $POSTGRES_PASSWORD_FILE)
export GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)

export USGS_USER=$(cat $USGS_USER_FILE)
export USGS_PASSWORD=$(cat $USGS_PASSWORD_FILE)
echo "machine urs.earthdata.nasa.gov login $USGS_USER password $USGS_PASSWORD" > ~/.netrc
chmod 0600 ~/.netrc
touch ~/.urs_cookies

tcpserver 0.0.0.0 $GAIA_OSGEO_API_PORT ./api.sh