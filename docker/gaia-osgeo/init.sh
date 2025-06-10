#!/bin/bash

export POSTGRES_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)
export GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)

tcpserver 0.0.0.0 $GAIA_OSGEO_API_PORT ./api.sh