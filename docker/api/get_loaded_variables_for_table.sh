psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
SELECT variable_name as attr from backbone.attr_index where table_name='$1';
"