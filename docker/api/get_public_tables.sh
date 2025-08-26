psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
SELECT table_name as public
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE' AND table_name != 'spatial_ref_sys';
"