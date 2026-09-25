#!/usr/bin/env bash

# create empty password files for the gaiaDocker environment. 
# NOTE: this will not overwrite existing secrets

if [ ! -f ./secrets/github_pat ]; then touch ./secrets/github_pat; fi
if [ ! -f ./secrets/gaia/AIRNOW_API_KEY ]; then touch ./secrets/gaia/AIRNOW_API_KEY; fi
if [ ! -f ./secrets/gaia/CDC_APP_TOKEN ]; then touch ./secrets/gaia/CDC_APP_TOKEN; fi
if [ ! -f ./secrets/gaia/CENSUS_API_KEY ]; then touch ./secrets/gaia/CENSUS_API_KEY; fi
if [ ! -f ./secrets/gaia/COPERNICUS_KEY ]; then touch ./secrets/gaia/COPERNICUS_KEY; fi
if [ ! -f ./secrets/github_patgaia/USGS_PASSWORD ]; then touch ./secrets/gaia/USGS_PASSWORD; fi
if [ ! -f ./secrets/github_patgaia/USGS_USER ]; then touch ./secrets/gaia/USGS_USER; fi

echo all secrets checked and created as empty if none found