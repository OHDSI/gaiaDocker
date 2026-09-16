# Start from an official Degauss image
FROM ghcr.io/degauss-org/geocoder

# install plumber for an API
RUN Rscript -e 'install.packages("plumber")'

# copy the app and start it running
COPY ./gaia-degauss/app/*.R /app
WORKDIR /app
# CMD ["Rscript","degauss.R"]

ENV GAIA_DEGAUSS_API_PORT=5150