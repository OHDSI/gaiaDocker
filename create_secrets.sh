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

# internal secrets: a random value when the file is missing or empty (the repository used to ship fixed defaults; a file that
# already holds a value is left alone, since an existing database was created with it)
gen_secret() {
  if [ ! -s "$1" ]; then
    (umask 077; openssl rand -hex 16 2>/dev/null > "$1" || head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n' > "$1")
  fi
}
gen_secret ./secrets/gaia/POSTGRES_PASSWORD
gen_secret ./secrets/gaia/AUTHENTICATOR_PASSWORD
gen_secret ./secrets/gaia/PGADMIN_PASSWORD
gen_secret ./secrets/gaia/GAIA_X_API_KEY
gen_secret ./secrets/hades/HADES_PASSWORD

echo all secrets checked and created as empty if none found