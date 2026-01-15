#!/bin/bash

psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
SELECT backbone.gdsc_load_variable('$1');
"
