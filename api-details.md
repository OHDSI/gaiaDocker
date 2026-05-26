# API documentation

More detailed documentation on the APIs in use within gaiaDocker. Note that the API calls are made through the gaia-default network created by docker compose. They should also be available on localhost as noted for each profile.

```
# terminolgy in this document

<layer> is the principal layer ID as a name
# ma_2022_svi_tract

<path to layer> is of the form /data/<layer>
# /data/ma_2022_svi_tract
```

##  `--profile gaia`

This is a postgrest API that interacts directly with the gaiacore database in the gaia-db container. The port below is the default and can be set in the top level file .env.

| profile | gaia-default | localhost |
| ------ | ------ | ------ |
| gaia | gaia-postgrest:3000 | localhost:3000 |

All database schemas, functions, tables, views and so on are available through the postgrest API (as set in the 01_init_schema.sql of gaiaDB). The bare endpoint will return a swagger description of the postgrest API that follows the OpenAPI specification. See the [docs](https://docs.postgrest.org/en/v14/).

Here are a few example calls (a subset of what is available).

### load source table

Through the API run a bash script that leverages a download mechanism coupled to gdal/ogr.

```
http://gaia-postgrest:3000/rpc/gdsc_exec
payload = {
    "shell": "bash",
    "script": "bash <path to layer>/etl/<layer>_osgeo"
}

# url form
http://locahost:3000/rpc/gdsc-exec?shell=bash&script=/data/<layer>/etl/<layer>_osgeo
```

### run transforms

Through the API run a SQL script to clean up the table ready for use.

```
http://gaia-postgrest:3000/rpc/gdsc_exec
payload = {
    "shell": "bash",
    "script": "bash <path to layer>/etl/<layer>_postgis"
}

# url form
http://locahost:3000/rpc/gdsc-exec?shell=bash&script=/data/<layer>/etl/<layer>_postgis
```

### load a variable

Through the API load one variable with its associated geom and attr tables in the _working_ schema of gaia-db.

Note: the references to the _variable_ are for use within the flask app running in the gaia-catalog container, but can be substituted with values of your choice.

TODO: make this structure match the json-ld structure in gaiaCatalog.

```
http://gaia-postgrest:3000/rpc/gdsc_load_variable
payload = {
    "params": {
        "table_id": layer_id,
        "table_description": document['dct_description'][0],
        "geom_type": document['locn_geometry'][0],
        "geom_label": document['gdsc_label'][0],
        "variable_nodata": 'Null' if 'gdsc_nodata' not in document else document['gdsc_nodata'][1],
        "variable_id": variable[0],
        "description": variable[1],
        "source": variable[2],
        "type": variable[3],
        "unit": variable[4],
        "unit_concept_id": None if variable[5] == "Null" else int(variable[5]),
        "min_val": None if variable[6] == "Null" else float(variable[6]),
        "max_val": None if variable[7] == "Null" else float(variable[7]),
        "start_date": make_iso_date(variable[8]),
        "end_date": make_iso_date(variable[9]),
        "concept_id": None if variable[10] == "Null" else int(variable[10])
    }
}

# url form
http://gaia-postgrest:3000/rpc/gdsc_load_variable?params={"table_id": <layer_id>,"table_description": <table description>,"geom_type": <raster|vector>,"geom_label": <label field for cartography>,"variable_nodata": <no data value|null>,"variable_id": <variable_id>,"description": <variable description>,"source": <variable source as text>,"type": <int|numeric|text>,"unit": <unit as text>,"unit_concept_id": <unit_concept_id>,"min_val": <minval as float|null>,"max_val": <maxval as float|null>,"start_date": <iso date>,"end_date": <iso date>,"concept_id": <concept_id>}
```

## `--profile gdsc-tcp-api`

This is a homegrown tcpserver based API that interacts with the gaia-db container through secondary isolated data processing containers. The ports below are the defaults and can be changed in the top level file .env.

| profile | gaia-default | localhost |
| ------ | ------ | ------ |
| gaia-tcp-api | gaia-osgeo:9800 | localhost:9800 |
| gaia-tcp-api | gaia-postgis:9801 | localhost:9801 |
| gaia-tcp-api | gaia-git:9802 | localhost:9802 |
| gaia-tcp-api | gaia-gdsc:9803 | localhost:9803 |

Here are a few examples (subset of what is available).

### load source table

Through the API call a bash script that leverages a download mechanism coupled to gdal/ogr on the gaia-osgeo container.

```
http://gaia-osgeo:9800/
payload = 'bash <path to layer>/etl/<layer>_osgeo.sh'
```
Through the API call a SQL script  on the gaia-postgis container to clean up the table ready for use.

```
http://gaia-postgis:9801/
payload = 'bash <path to layer>/etl/<layer>_postgis.sh'
```

### load variable

Through the API call a SQL script on the gaia-postgis container to clean up the table ready for use.

Note: the references to the _variable_ are for use within the flask app running in the gaia-catalog container, but can be substituted with values of your choice.

TODO: make this structure match the json-ld structure in gaiaCatalog.

```
http://gaia-postgis:9801/
payload = 'bash gdsc_load_variable.sh {
        "table_id": layer_id,
        "table_description": document['dct_description'][0],
        "geom_type": document['locn_geometry'][0],
        "geom_label": document['gdsc_label'][0],
        "variable_nodata": 'Null' if 'gdsc_nodata' not in document else document['gdsc_nodata'][1],
        "variable_id": variable[0],
        "description": variable[1],
        "source": variable[2],
        "type": variable[3],
        "unit": variable[4],
        "unit_concept_id": None if variable[5] == "Null" else int(variable[5]),
        "min_val": None if variable[6] == "Null" else float(variable[6]),
        "max_val": None if variable[7] == "Null" else float(variable[7]),
        "start_date": make_iso_date(variable[8]),
        "end_date": make_iso_date(variable[9]),
        "concept_id": None if variable[10] == "Null" else int(variable[10])
    }'
```
