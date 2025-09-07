#!/bin/bash

export PG_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)
export GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)
export USGS_USER=$(cat $USGS_USER_FILE)
export USGS_PASSWORD=$(cat $USGS_PASSWORD_FILE)

tcpserver 0.0.0.0 $GAIA_OSGEO_API_PORT ./api.sh