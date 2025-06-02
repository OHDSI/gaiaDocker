#!/bin/bash

# global_pm25_concentration_1998_2016_osgeo.sh
# Download and ETL into postGIS from osgeo_postgis container
#
# Data source: file:///data/data/global_pm25_concentration_1998_2016/download/sdei-annual-pm2-5-concentrations-countries-urban-areas-v1-1998-2016-urban-areas.shp
# Destination postGIS table: global_pm25_concentration_1998_2016
#
# Created by etl() on 2025-05-16 13:23:16
# Do not edit directly

# create directory structure and move into it
mkdir -p /data/global_pm25_concentration_1998_2016/{download,etl} && cd /data/global_pm25_concentration_1998_2016

# check for existence
export TZ=EST5EDT
do_update=0
list=$(ls)
file=datestamp
exists=$(test "${list#*$file}" != "$list" && echo 1)
if [[ $exists ]]; then

# check need for update based on update frequency
update_frequency='As Needed'
no_update='-- As Needed Never'
no_update=$(test "${no_update#*$update_frequency}" != "$no_update" && echo 1)
if [[ ! $no_update ]]; then
last_update=$(date -d "$(cat datestamp)" '+%s')
check_date="$(date -d '-'"$update_frequency" '+%s')"
if [[ "$check_date -ge $last_update" ]]; then do_update=1; fi
fi

# does not exist
else do_update=1; fi

# download if needed
if [[ $do_update = 1 ]]; then
  (exit 1)
  until [[ "$?" == 0 ]]; do
      wget -O download/global_pm25_concentration_1998_2016.zip 'https://sedac.ciesin.columbia.edu/downloads/data/sdei/sdei-annual-pm2-5-concentrations-countries-urban-areas-v1-1998-2016/sdei-annual-pm2-5-concentrations-countries-urban-areas-v1-1998-2016-urban-areas-shp.zip'
  done
  unzip -d download download/global_pm25_concentration_1998_2016.zip && rm download/global_pm25_concentration_1998_2016.zip
  # record download datestamp
  echo $(date '+%F %T') > datestamp
fi

# load into postGIS
(exit 1)
until [[ "$?" == 0 ]]; do
  ogr2ogr -lco GEOMETRY_NAME=geom -f PostgreSQL PG:"dbname=$POSTGRES_DB port=$POSTGRES_PORT user=$POSTGRES_USER password=$(cat $POSTGRES_PASSWORD_FILE) host='gaia-db'" download/sdei-annual-pm2-5-concentrations-countries-urban-areas-v1-1998-2016-urban-areas.shp -nlt multipolygon -nln global_pm25_concentration_1998_2016
done

