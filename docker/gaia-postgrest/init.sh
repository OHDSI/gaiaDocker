#!/bin/sh

# set the postgrest uri with user and pass
export POSTGRES_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)
export PGRST_DB_URI=postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@gaia-db:5432/$POSTGRES_DB

# run postgrest
postgrest
