#!/bin/bash

psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
SELECT EXISTS (
	SELECT FROM information_schema.tables 
	WHERE  table_schema = 'public'
	AND    table_name   = '$1'
);
"
