#!/bin/bash

# ma_2018_svi_tract_postgis.sh
# Finish ETL into postGIS from postgis_postgis container
#
# Data source: https://svi.cdc.gov/Documents/Data/2018/db/states/Massachusetts.zip
# Destination postGIS table: ma_2018_svi_tract
#
# Created by etl() on 2025-05-16 13:23:41
# Do not edit directly

# remove duplicate points and make geometries valid:
psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
UPDATE ma_2018_svi_tract
  SET geom=ST_MakeValid(ST_RemoveRepeatedPoints(geom));"

# add local geometry column and reproject existing geometries into local EPSG:
psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
SELECT AddGeometryColumn (
  'ma_2018_svi_tract',
  'geom_local', 26986, 'multipolygon', 2
);
UPDATE ma_2018_svi_tract
  SET geom_local=ST_MakeValid(ST_RemoveRepeatedPoints(ST_Transform(ST_Multi(geom), 26986)));
CREATE INDEX ma_2018_svi_tract_geom_local_idx
  ON ma_2018_svi_tract
  USING GIST (geom_local);
NOTIFY pgrst, 'reload schema';"
