#!/bin/sh

export GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)

exec "$@"