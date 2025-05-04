## gaia-db build for gaiaDocker (initially from conatinerize branch on https://github.com/OHDSI/GIS)

### notes:

Dockerfile:
   - multistage build allows the Dockerfile to pull content from other repositories, this will likely be useful as content comes from the vocabulary team and the db team.
   - currently init.sql lives here, but could be also from the main OHDSI/GIS repository 

