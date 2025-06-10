#!/bin/sh

export GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)
tcpserver 0.0.0.0 $GAIA_GIT_API_PORT ./api.sh