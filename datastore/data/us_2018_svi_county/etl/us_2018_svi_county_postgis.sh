#!/bin/bash

# us_2018_svi_county_postgis.sh
# Finish ETL into postGIS from postgis_postgis container
#
# Data source: https://svi.cdc.gov/Documents/Data/2018/db/states_counties/SVI_2018_US_county.zip
# Destination postGIS table: us_2018_svi_county
#
# Created by etl() on 2025-05-16 13:23:58
# Do not edit directly

# remove duplicate points and make geometries valid:
psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
UPDATE us_2018_svi_county
  SET geom=ST_MakeValid(ST_RemoveRepeatedPoints(geom));"

# add local geometry column and reproject existing geometries into local EPSG:
psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
SELECT AddGeometryColumn (
  'us_2018_svi_county',
  'geom_local', 6350, 'multipolygon', 2
);
UPDATE us_2018_svi_county
  SET geom_local=ST_MakeValid(ST_RemoveRepeatedPoints(ST_Transform(ST_Multi(geom), 6350)));
CREATE INDEX us_2018_svi_county_geom_local_idx
  ON us_2018_svi_county
  USING GIST (geom_local);
NOTIFY pgrst, 'reload schema';"
