# gaiaDocker

## Introduction

gaiaDocker runs the core OHDSI GIS technology stack using cross-platform Docker container technology.

[Information on Observational Health Data Sciences and Informatics (OHDSI)](http://www.ohdsi.org/ "OHDSI Website")

This repository contains the Docker Compose file used to launch the OHDSI gaiaDocker Docker containers:

- the OHDSI GIS gaia stack
    - gaia-core
	- gaia-db  
	- gaia-vocabulary
	- gaia-catalog
	- gaia-solr
	- gaia-degauss
	- gaia-osgeo

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

If using Mac Silicon (M1, M2), you **may** need to set the DOCKER_ARCH variable in Section 1 of the .env file to "linux/arm64". Some Broadsea services still need to run via emulation of linux/amd64 and are hard-coded as such.

## gaiaDocker - Quick start

- Download and install Docker. See the installation instructions at the [Docker Web Site](https://docs.docker.com/engine/installation/ "Install Docker")
- git clone this GitHub repo:

```shell
git clone git@github.com:OHDSI/gaiaDocker.git
```

- In a command line / terminal window - navigate to the directory where this README.md file is located and start the gaia Docker Containers using the below command. On Linux you may need to use 'sudo' to run this command. Wait up to one minute for the Docker containers to start.

```shell
docker compose --profile gaia up -d
```

### Build Notes:  

- containers will build the first time the above command is run. It may take several mintues.  
- the containers should run, but nothing has been tested ... yet

## gaiaDocker - Quick end

- In the directory where this README.md is locatred, in a command line / terminal window, use the below command to terminate the containers.  

```shell
docker compose --profile gaia down
```

## NOTE: containers will build the first time (may take a while)