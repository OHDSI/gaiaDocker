# gaiaDocker

This repository containes a docker compose file and a set of specifications for docker containers that integrate work from the [OHDSI GIS workgroup](https://github.com/OHDSI). Specificially, gaiaDocker provides integration between the [gaiaDB](https://github.com/OHDSI/gaiaDB) and [gaiaCatalog](https://github.com/OHDSI/gaiaCatalog) projects through a browser-based dataset discovery tool. gaiaDocker is built based on the [OHDSI Broadsea](https://github.com/OHDSI/broadsea) architecture.

> **Status:** under active development

## Contents

- [Docker Installation](#dockeriinstallation)
- [Quick Start](#quick-start)
- [Shutdown](#shutdown)
- [gaiaDocker for Development](#gaiadocker-for-development)
- [Secrets](#secrets)
- [Profiles](#profiles)
- [Architecture](#architecture)
- [Database Maintenance](#database-maintenance)
- [Degauss geocoder](#degauss-geocoder)
- [Support](#support)
- [Developer Guidelines](#developer-guidelines)


## Docker Installation

### Dependencies  

- Linux, Mac, or Windows with WSL
- Docker 1.27.0+
- Docker Compose 2.0+
- Git
- Chromium-based web browser (Chrome, Edge, etc.)
- 50GB+ disk space

### Docker

**For gaiaDocker, you will need Docker version 1.27.0+.**  
Download and install Docker. 
   - Windows: See the installation instructions for Docker Desktop at the [Docker Web Site](https://docs.docker.com/desktop/setup/install/windows-install/ "Install Docker PC"). NOTE: you will have to either install WSL or Hyper-V. This repo has been tested on WSL.
   - Apple: See the installation instructions for Docker Desktop at the [Docker Web Site](https://docs.docker.com/desktop/setup/install/mac-install/ "Install Docker Mac"). NOTE: you can also use Colima (from your shell/terminal):
      ```shell
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      brew install colima
      ```

#### A Note on Docker Compose V2  

Throughout this README, we will show docker compose commands with the convention of `docker compose` (with no hyphen), per the new Docker Compose V2 standard outlined by [Docker](https://docs.docker.com/compose/migrate/#docker-compose-vs-docker-compose).  You may need to use `docker-compose` dpending on your version of docker.


## Quick Start

The fastest way to deploy gaiaDocker is from the command line (terminal/bash on mac/linux or powershell on windows):

```bash
# Clone gaiaDocker repository
git clone https://github.com/OHDSI/gaiaDocker.git
git clone https://github.com/OHDSI/gaiaCatalog.git
cd gaiaDocker
```

### create blank secrets (only do this once)

The Gaia toolchain leverages Docker secrets to enable data retrieval from datasources that require authentication. For the quickstart we recommend running the script in the gaiaDocker root directory to create empty secrets, and then see the [Gaia secrets documentation](secrets/gaia/README.md) for instructions to create the secrets for the sources you will use.  

mac/linux
```bash
bash ./create_secrets.sh
```

windows
```bash
./create_secrets.ps1 # windows
```

### start the full Gaia stack

```bash
# Start the full Gaia stack
docker compose --profile gaia up -d
```

On the first start it may take several minutes to pull the containers from the docker hub container repository. NOTE: there are several profiles available (see [Profiles](#profiles)).

### verify services are running
```
# Verify services are running
docker compose ps
```

**What's deployed**:
- **gaia-db**: PostgreSQL/PostGIS (core data repository)  
- **gaia-postgrest**: PostgREST API (exposes gaiaDb functions)  
- **gaia-catalog**: Data source discovery interface  
- **gaia-solr**: Search engine for catalog  

### testing

You can test various endpoints from the command line

```bash
# connect to the gaia-db database ...
# result: you will enter into a psql command line environment
docker compose exec gaia-db psql -U postgres -d gaiacore 

# test the postgrest API ...
# result: you will see a long sumamry of available funcitonality
curl http://localhost:3000/
```

You can also use a web browser to navigate to:

- `http://localhost:5001`: the catalog discovery application
- `https://ohdsi.github.io/gaiaCatalog/browser`: an alternative catalog browser

From the main pages of either browser you can view descriptive entries for datasets available in the catalog.

### Dataset Ingestion

On the either catalog browser click on the red dot next to the dataset name to start the dataset ingestion pipeline. The application will communicate with the gaia-db container and set in motion a pipeline to retrieve the data from an external source and then ETL the dataset into a staging table in the _public_ schema of the _gaiacore_ postgis database.

If the process completes successfully the dot will turn green.

### Variable Ingestion

Navigate to a dataset detail view by clicking a dataset title. On the view for the variable level metadata, click on a red dot next to a variable name to start the variable ingestion pipeline. The application will communicate with the gaia-db container and set in motion a pipeline to ingest geometries and attribute for the chosen variable into the respective geom and attr tables in the _working_ schema of the _gaiacore_ database running on the gaia-db container. Metadata for the geometries and attribute will also be ingested into the geom-index and attr_index tables of the _backbone_ schema of the _gaiacore_ database.

If the process completes successfully the dot will turn green.

### Next Steps

Once you have all of you variables loaded you can proceed to the spatial join steps in the _gaiacore_ database on the gaia-db container. For more information about these ingestion steps and the spatial join see the README at [gaiaDB](https://github.com/OHDSI/gaiaDB).

## Shutdown

You do not have to shut the docker compose down, but it does consume resources in the background and a graceful shutdown is recommended. Note that the Postgis data directory for the _gaiacore_ database on the gaia-db container and the SOLR index on the gaia-solr container will persist between sessions.

```shell
cd ./gaiaDocker
docker compose --profile gaia down
```

Note that you must use the same profile(s) in the `docker compose down` command that you used in the `docker compuse up` command. See [Profiles](#profiles) below.

## gaiaDocker for development

Run the following script in your shell will gather the three required components of the OHDSI gaiaDocker project and create local builds for the gaia-db and gaia-catalog containers.

```shell
git clone git@github.com:OHDSI/gaiaDocker.git
git clone git@github.com:OHDSI/gaiaDB.git # not needed unless building for development
git clone git@github.com:OHDSI/gaiaCatalog.git

# the build is only useful for development
cd gaiaDB
docker build -t gaia-db .

# the build is only useful for development
cd ../gaiaCatalog
docker build -t gaia-catalog .
```

### Mac Silicon  

If using Mac Silicon (M1, M2, etc), you _may_ need to set the DOCKER_ARCH variable in Section 1 of the .env file to "linux/arm64" (line 5). Some Broadsea services still need to run via emulation of linux/amd64 and are hard-coded as such.  

It is likely the gaia-core container will run, but RStudio login will fail on Mac Silicon. The base Hades image upon which this version of gaia-core is built is only maintained for amd64 architectures.  

### Additional Views and Functionality 

Once all containers are running with either the gaia or gaia-tcp-api profiles you can explore these additional views and functionality.

- In the gaia-solr (localhost:8983) you can explore the two indexes (collections and dcat). The dcat collection is the index for the data layers.
- In the gaia-core (localhost:8787) you can login as user:ohdsi with pass:mypass to run RStudio with the geospatial extensions loaded (windows only)
- You can connect to the _gaiacore_ database on the gaia-db container with a postgres client like PGAdmin or QGIS with host:localhost, port:5433, database:gaiacore, user:postgres, pass:SuperSecret (these are the defaul values in the top level .env file).

## Secrets  

The Gaia toolchain leverages Docker secrets to enable data retrieval from datasources that require authentication. All secrets are in the top-level ./secrets folder. For gaiaDocker there is a gaia subfolder with gaia specific secrets. For the quickstart we recommend running the script below to create empty secrets, and then see the [Gaia secrets documentation](secrets/gaia/README.md) for instructions to create the secrets for the sources you will use.  

mac/linux
```bash
bash ./create_secrets.sh
```

windows
```shell
./create_secrets.ps1 # windows
```

Note that you should change your internal secrets (postgres, internal API, etc) and that you will need to provide your own external API secrets (Copernicus, Census, Earth Explorer, and so on).  

If you do not have keys and authenticator accounts for the external APIS see the [README.md](secrets/gaia/README.md) in the secrets/gaia directory of this repository for instructions on how to create them.

## Profiles  

You can choose from two base profiles and then add-on additional profiles as needed.

| Profile | Use Case |
| ------ | ------ |
| gaia | Runs the integrated stack using the postgrest API. Choose this for most use cases. |
| gaia-tcp-api | Runs the integrated stack using the tcp-base API and isolated ETL processes (experimental). |
| gaia-core | Runs the additional Hades image with the gaia analytic toolset. This depends on either gaia or gaia-tcp-api. |
| degauss | Runs the degauss geocoder. | 

An example with two ptofiles loaded:
```bash
# Run as the basic configuration with the postgrest API and the degauss container
docker compose --profile gaia --profile degauss up -d
```

Note that you must use the same profile(s) in both `docker compose up` and    `docker compose down`.

## Architecture

This repository contains the Docker Compose file used to launch the OHDSI gaiaDocker integration. It is based on the [OHDSI Broadsea](https://github.com/OHDSI/Broadsea) implementation with future integration in mind.  Docker containers:

| Container | Profile(s) | Purpose | Image at OHDSI github |
|:---------|:--------|:----------|:----------|
|gaia-db|gaia, gaia-db, gaia-tcp-api|Postgis relational database as GIS datastore with gaia plugins|[OHDSI/gaiaDB#main:./](https://github.com/OHDSI/gaiaDB)|
|gaia-catalog|gaia, gaia-tcp-api|Python flask app discovery tool running at [http://localhost:5000](http://localhost:5000)|[OHDSI/gaiaCatalog#main:./docker/repository](https://github.com/OHDSI/gaiaCatalog)|
|gaia-postgrest|gaia|postgrest API running at  [http://localhost:3000](http://localhost:3000)|[OHDSI/gaiaDocker#main:./docker/gaia-postgrest](https://github.com/OHDSI/gaiaDocker)|
|gaia-solr|gaia, gaia-tcp-api|solr index of all catalog entries at [http://localhost:8983](http://localhost:8983)|[OHDSI/gaiaCatalog#main:./docker/solr](https://github.com/OHDSI/gaiaCatalog)|
|gaia-osgeo|gaia-tcp-api|isolated gdal/ogr toolset for ETL|[OHDSI/gaiaDocker#main:./docker/ohdsi-osgeo](https://github.com/OHDSI/gaiaDocker)|
|gaia-postgis|gaia-tcp-api|isolated postgis toolset for ETL|[OHDSI/gaiaDocker#main:./docker/ohdsi-postgis](https://github.com/OHDSI/gaiaDocker)|
|gaia-git|gaia-tcp-api|isolated git for using external code|[OHDSI/gaiaDocker#main:./docker/ohdsi-git](https://github.com/OHDSI/gaiaDocker)|
|gaia-gdsc|gaia-tcp-api|isolated python environment for data processing|[OHDSI/gaiaDocker#main:./docker/ohdsi-gdsc](https://github.com/OHDSI/gaiaDocker)|
|gaia-core|gaia-core|Hades based R environment with additional GIS toolchain|[OHDSI/GIS#containerize:./docker/gaia-core](https://github.com/OHDSI/GIS)  
|gaia-degauss|degauss|degauss geocoder for adding lat/lon to address information. Note this build has the R plumber and degauss packages installed and configuresd so you can access the degauss API with R.|[OHDSI/gaiaDocker#main:./docker/gaia-degauss](https://github.com/OHDSI/gaiaDocker/docker/gaia-degauss)|

## Database Maintenance

Both the postGIS database in gaia-db and SOLR index in gaia-solr will persist on your local machine when docker is stopped or the machine powers off. In any case, sometimes it will be necessary to reset the PostGIS database and / or the SOLR index for the catalog.

### Reset the gaia-db postGIS Database

To reset the postGIS database to default it is easiest to rebuild the gaia-db docker image and the gaia-db docker volume. To do this navigate to the gaiaDocker directory in a command line / terminal window and run:

```shell
docker-compose --profile gaia down
docker image rm gaia-db
docker volume rm gaia-db
docker-compose --profile gaia up -d
```

Note that you can do this with any profile(s) that you are using.

### Update the gaia-catalog Entries

You can update the catalog entires by pulling new json files from the gaiaCatalog repository. In a command line / terminal window navigate to the gaiaCatalog directory and run:

```shell
cd gaiaCatalog
git pull origin main
```

This updates the json files used as the source of truth for the catalog. NOTE: once the json is updated, the SOLR index must also be updated. 

### Update the SOLR Index

The easiest way to do this is to navigate to the gaiaDocker directory in a command line / terminal window and rebuild the gaia-solr docker image and gaia-solr docker volume as follows:

```shell
cd gaiaDocker
docker-compose --profile gaia down
docker image rm gaia-solr
docker volume rm gaia-solr
docker-compose --profile gaia up -d
```
Note that you can do this with any profile(s) that you are using.

## Degauss geocoder

The gaia-degauss image included in the Gaia toolchain is a copy of the latest [degauss geocoder](https://degauss.org/geocoder/) with the R plumber and degauss packages installed. This allows a degauss integration in the gaiaCore Hades container or any other R environment. To use locate the variable $GAIA_DEGAUSS_API_PORT in the .env file (default 5150):

```
https://localhost:$GAIA_DEGAUSS_API_PORT/geocode?address=URLeconcdedAddressString
```

You can also use the standard degauss APIs for the geocoder. See their [documentation](https://degauss.org/geocoder/).

## Support

Please use the [GitHub issue tracker](https://github.com/OHDSI/gaiaDocker/issues) for bugs and feature requests.

---

## Developer Guidelines

- Open an issue before starting significant work
- Create a feature branch and submit a Pull Request when ready
- PRs require review before merge to `main`
