#!/bin/bash

# tz_1984_copernicus_avg_temp_osgeo.sh
# Download and ETL into postGIS from osgeo_postgis container
#
# Data source: https://github.com/tibbben/copernicus_aggregate.git
# Destination postGIS table: tz_1984_copernicus_avg_temp
#
# Created by etl() on 2025-06-02 22:13:11
# Do not edit directly

# create directory structure and move into it
mkdir -p /data/tz_1984_copernicus_avg_temp/{download,etl} && cd /data/tz_1984_copernicus_avg_temp

# record podID
echo postgis-mvznqevo8s0vzrl3 > /data/tz_1984_copernicus_avg_temp/podID

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

cd download
gdal_translate NETCDF:tz_1984_copernicus_avg_temp.nc:2m_temperature tz_1984_copernicus_avg_temp.tif
cd ..


