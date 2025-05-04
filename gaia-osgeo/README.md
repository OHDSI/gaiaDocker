## osgeo build for gaiaDocker

### notes:

This container is used for ETL only.  

dockerfile:
   - the vim install is not necessary, but useful for development  
   - the ucspi-tcp install is used to create a lightweight api (POST only)

the api:
   - provides way for docker containers to communicate securely with this container 
   - from: https://medium.com/@costaparas/turning-a-shell-script-into-a-web-api-a9214cac4934
   - could be anything really, this seemed like a good solution for now
