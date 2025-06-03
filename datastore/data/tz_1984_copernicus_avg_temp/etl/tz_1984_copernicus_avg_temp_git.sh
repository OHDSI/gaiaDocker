#!/bin/bash

# tz_1984_copernicus_avg_temp_git.sh
# Finish ETL into postGIS from git_postgis container
#
# Data source: https://github.com/tibbben/copernicus_aggregate.git
# Destination postGIS table: tz_1984_copernicus_avg_temp
#
# Created by etl() on 2025-06-02 22:13:11
# Do not edit directly

# create directory structure and move into it
mkdir -p /data/tz_1984_copernicus_avg_temp/download && mkdir -p /data/tz_1984_copernicus_avg_temp/etl && cd /data/tz_1984_copernicus_avg_temp

git clone https://github.com/tibbben/copernicus_aggregate.git scripts

