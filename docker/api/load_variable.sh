#!/bin/bash

psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
SELECT gaia.gaia_load_variable('$1','$2','$3','$4','$5','$6','$7','$8','$9','${10}',${11},${12},${13},'${14}','${15}',${16});
"
