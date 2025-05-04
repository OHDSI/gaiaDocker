# gaiaDocker

## Introduction

gaiaDocker runs the core OHDSI GIS technology stack using cross-platform Docker container technology.

[Information on Observational Health Data Sciences and Informatics (OHDSI)](http://www.ohdsi.org/ "OHDSI Website")

This repository contains the Docker Compose file used to launch the OHDSI gaiaDocker Docker containers:

- the OHDSI GIS gaia stack [ with: --profile gaia ]
    - gaia-core  
      Hades based R environment with additional GIS toolchain
	- gaia-db  
	  postgis relational database as GIS datastore
	- gaia-catalog  
	  python flask app as an interface to gaia-solr at [http://localhost:5000](http://localhost:5000)
	- gaia-osgeo  
	  gdal/ogr toolset for ETL
	- gaia-postgis  
	  postgis toolset for ETL
	- gaia-solr  
	  solr index of all catalog entries at [http://localhost:8983](http://localhost:8983)
-  additional tools [ optional ] [ with: --profile degauss ]
	- gaia-degauss  
	  degauss geocoder for adding lat/lon to address information 

This repository is based on the [OHDSI Broadsea](https://github.com/OHDSI/Broadsea) implementation with future integration in mind.

### A Note on Docker Compose V2

Throughout this README, we will show docker compose commands with the convention of `docker compose` (no hyphen), per the new Docker Compose V2 standard outlined by [Docker](https://docs.docker.com/compose/migrate/#docker-compose-vs-docker-compose).

**For gaiaDocker, you will need Docker version 1.27.0+.**

### Dependencies

- Linux, Mac, or Windows with WSL
- Docker 1.27.0+
- Git
- Chromium-based web browser (Chrome, Edge, etc.)

### Mac Silicon

If using Mac Silicon (M1, M2, etc), you **may** need to set the DOCKER_ARCH variable in Section 1 of the .env file to "linux/arm64". Some Broadsea services still need to run via emulation of linux/amd64 and are hard-coded as such.

## gaiaDocker - Quick start

- Download and install Docker. See the installation instructions at the [Docker Web Site](https://docs.docker.com/engine/installation/ "Install Docker")
- git clone this GitHub repo:

```shell
git clone git@github.com:OHDSI/gaiaDocker.git
```

- In a command line / terminal window - navigate to the directory where this README.md file is located and start the gaia Docker Containers using the below command. On Linux you may need to use 'sudo' to run this command.

```shell
docker compose --profile gaia up -d
```

### Build Notes:  

- The first time the above command is run it will take several mintues for the containers to build.
- The containers will run and you can explore, but there is no functionality yet (stay tuned).

## gaiaDocker - Quick end

- In the directory where this README.md is located, in a command line / terminal window, use the below command to terminate the containers.  

```shell
docker compose --profile gaia down
```
