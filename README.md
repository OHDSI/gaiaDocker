# gaiaDocker

## Introduction

gaiaDocker runs the core OHDSI GIS technology stack using cross-platform Docker container technology.

[Information on Observational Health Data Sciences and Informatics (OHDSI)](http://www.ohdsi.org/ "OHDSI Website")

This repository contains the Docker Compose file used to launch the OHDSI gaiaDocker Docker containers:

- the OHDSI GIS gaia stack [ with: --profile gaia ]
  - gaia-core  
    Hades based R environment with additional GIS toolchain  
    image: [OHDSI/GIS#containerize:./docker/gaia-core](https://github.com/OHDSI/GIS)  
  - gaia-db  
	  postgis relational database as GIS datastore  
	  image: [OHDSI/gaiaDB#main:./](https://github.com/OHDSI/gaiaDB)  
  - gaia-catalog  
	  python flask app as an interface to gaia-solr at [http://localhost:5000](http://localhost:5000)  
	  image: [OHDSI/gaiaCatalog#main:./docker/repository](https://github.com/OHDSI/gaiaCatalog)  
  - gaia-solr  
	  solr index of all catalog entries at [http://localhost:8983](http://localhost:8983)  
	  image: [OHDSI/gaiaCatalog#main:./docker/solr](https://github.com/OHDSI/gaiaCatalog)  
  - gaia-osgeo  
	  gdal/ogr toolset for ETL  
	  image: [OHDSI/gaiaDocker#main:./docker/ohdsi-osgeo](https://github.com/OHDSI/gaiaDocker)  
  - gaia-postgis  
	  postgis toolset for ETL  
	  image: [OHDSI/gaiaDocker#main:./docker/ohdsi-postgis](https://github.com/OHDSI/gaiaDocker)  
  - gaia-git  
	  git for using external code  
	  image: [OHDSI/gaiaDocker#main:./docker/ohdsi-git](https://github.com/OHDSI/gaiaDocker)  
  - gaia-gdsc  
	  python environment for data processing  
	  image: [OHDSI/gaiaDocker#main:./docker/ohdsi-gdsc](https://github.com/OHDSI/gaiaDocker)  

-  additional tools [ optional ] [ with: --profile degauss ]  
	- gaia-degauss  
	  degauss geocoder for adding lat/lon to address information  
	  image: [GDSC/docker#ohdsi:./builds/degauss](https://github.com/Geospatial-Digital-Special-Collections/docker)  

This repository is based on the [OHDSI Broadsea](https://github.com/OHDSI/Broadsea) implementation with future integration in mind.  

### A Note on Docker Compose V2  

Throughout this README, we will show docker compose commands with the convention of `docker compose` (no hyphen), per the new Docker Compose V2 standard outlined by [Docker](https://docs.docker.com/compose/migrate/#docker-compose-vs-docker-compose).  

**For gaiaDocker, you will need Docker version 1.27.0+.**  

### Dependencies  

- Linux, Mac, or Windows with WSL
- Docker 1.27.0+
- Git
- Chromium-based web browser (Chrome, Edge, etc.)

### Secrets  

All secrets are in the top-level secrets folder. For gaiaDocker there is a gaia subfolder with gaia specific secrets. Note that syou should change your internal secrets (postgres, internal API, etc) and that you will need to provide your own external API secrets (Copernicus, Census, Earth Explorer, and so on).  

### Mac Silicon  

If using Mac Silicon (M1, M2, etc), you **may** need to set the DOCKER_ARCH variable in Section 1 of the .env file to "linux/arm64" (line 5). Some Broadsea services still need to run via emulation of linux/amd64 and are hard-coded as such.  

It is likely the gaia-core container will run, but RStudio login will fail on Mac Silicon. The base Hades image upon which this version of gaia-core is built is only maintained for amd64 architectures.  

## gaiaDocker - Quick start  

- Download and install Docker. See the installation instructions at the [Docker Web Site](https://docs.docker.com/engine/installation/ "Install Docker")
- git clone this GitHub repo:

```shell
git clone git@github.com:OHDSI/gaiaDocker.git
```

- Before starting gaiaDocker containers, you must authenticate to GitHub Container Registry (GHCR). This step is required to access the osgeo/gdal image. Detailed instructions [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry). Basic steps for authenticating in a command line / terminal window with a Personal Access Token (PAT) below:
```shell
# Create a GitHub PAT with read:packages scope in order to authenticate
export CR_PAT=YOUR_TOKEN

echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin

# > Login Succeeded
```

- In a command line / terminal window - navigate to the directory where this README.md file is located and start the gaia Docker Containers using the below command. On Linux you may need to use 'sudo' to run this command.

```shell
docker compose --profile gaia up -d
```

--or--  


```shell
docker-compose --profile gaia up -d
```

### Build Notes:  

- The first time the above command is run it will take several mintues for the containers to build.
- The containers will run and you can explore.  

### Existing Functionality (with default credentials)  

- In the gaia-catalog (locahost:5000) the red buttons next to the dataset name will load the specific layer into the public schema of the gaia-db when clicked. The structure of the source data is maintained to the extent possible. If successful the dot will turn green.
- In the gaia-solr (localhost:8983) you can explore the two indexes (collections and dcat). The dcat collection is the index for the data layers.
- In the gaia-core (localhost:8787) you can login as user:ohdsi with pass:mypass to run RStudio with the geospatial extensions loaded (windows only)
- You can connect to the gaia-db with a postgres client like PGAdmin or QGIS with host:localhost, port:5433, database:gaiaDB, user:postgres, pass:SuperSecret

## gaiaDocker - Quick end  

- In the directory where this README.md is located, in a command line / terminal window, use the below command to terminate the containers.  

```shell
docker compose --profile gaia down
```

--or--  


```shell
docker-compose --profile gaia down
```
