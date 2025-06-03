#!/bin/bash

# tz_1984_copernicus_avg_temp_gdsc.sh
# Finish ETL into postGIS from gdsc_postgis container
#
# Data source: https://github.com/tibbben/copernicus_aggregate.git
# Destination postGIS table: tz_1984_copernicus_avg_temp
#
# Created by etl() on 2025-06-02 22:13:11
# Do not edit directly

cd /data/tz_1984_copernicus_avg_temp/scripts
python copernicus_aggregate.py '{"table": "tz_1984_copernicus_avg_temp", "extension": "zip", "extent": ["29", "-12", "41", "-0.8"], "attributes": ["2m_temperature;Average yearly 2m temperature in Kelvin from Copernicus reanalysis era5 sinagle levels;Copernicus;float;Kelvin"], "bands": ["t2m"], "format": "nc"}' 1984

