#!/bin/bash

# global_pm25_concentration_1998_2016_postgis.sh
# Finish ETL into postGIS from postgis_postgis container
#
# Data source: file:///data/global_pm25_concentration_1998_2016/download/sdei-annual-pm2-5-concentrations-countries-urban-areas-v1-1998-2016-urban-areas.shp
# Destination postGIS table: global_pm25_concentration_1998_2016
#
# Created by etl() on 2025-05-16 13:23:16
# Do not edit directly

# remove duplicate points and make geometries valid:
psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
UPDATE global_pm25_concentration_1998_2016
  SET geom=ST_MakeValid(ST_RemoveRepeatedPoints(geom));"

# add local geometry column and reproject existing geometries into local EPSG:
psql -d $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -h gaia-db -c "
SELECT AddGeometryColumn (
  'global_pm25_concentration_1998_2016',
  'geom_local', 3857, 'multipolygon', 2
);
UPDATE global_pm25_concentration_1998_2016
  SET geom_local=ST_MakeValid(ST_RemoveRepeatedPoints(ST_Transform(ST_Multi(geom), 3857)));
CREATE INDEX global_pm25_concentration_1998_2016_geom_local_idx
  ON global_pm25_concentration_1998_2016
  USING GIST (geom_local);
NOTIFY pgrst, 'reload schema';"
