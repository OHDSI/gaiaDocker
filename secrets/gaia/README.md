# GaiaDocker Secrets

The GaiaDocker stack includes various secrets that can be grouped into two categories: internal (database and other docker secrets) and external (APIs).

### Internal Secrets

You should change the following secrets from their defaults:
- GAIA_X_API_KEY
- POSTGRES_PASSWORD

NOTE: this list does not include other keys that should be changed in the OHDSI Broadsea implementation.

### External APIs with authentication:

The catalog uses APIs to retrieve data, including APIs with account authentication. Currently we have the following list of APIs with authentication needs.

- __Copernicus Climate Data Store [https://cds.climate.copernicus.eu/](https://cds.climate.copernicus.eu/).__
   - Sign up for an account (top right of page)
   - Once you are logged in follow the [instructions](https://cds.climate.copernicus.eu/how-to-api) on how to create the API key. In the end it will look like this:
      ```
      url: https://cds.climate.copernicus.eu/api
      key: <your copernicus key here>
      ```
   - Then save the key file as COPERNICUS_KEY in this directory.

- __United States Geological Survey (USGS) [https://ers.cr.usgs.gov/login](https://ers.cr.usgs.gov/login)__. 
   - Create new account (bottom of left column)
   - You will use your username and password saved in two files in this directory for authentication (note the newline at the end of the files).  
	  USGS_USER
      ```
      <your USGS usesrname here>
      
      ```
	  USGS_PASSWORD
      ```
      <your USGS password here>
      
      ```