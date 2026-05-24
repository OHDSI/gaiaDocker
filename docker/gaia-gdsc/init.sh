#!/bin/sh

export GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)
cat $GAIA_COPERNICUS_KEY_FILE > ~/.cdsapirc

exec "$@"