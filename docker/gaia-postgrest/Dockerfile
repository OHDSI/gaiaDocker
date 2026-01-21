FROM postgrest/postgrest:latest

# copy the init script
USER root
COPY --chmod=777 ./gaia-postgrest/init.sh /init.sh

# run as 1000
USER 1000
ENTRYPOINT /init.sh