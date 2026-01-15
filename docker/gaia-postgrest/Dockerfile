FROM postgrest/postgrest:latest

WORKDIR /init

# copy the init script
COPY --chmod=777 ./gaia-postgrest/init.sh .

ENTRYPOINT ["./init.sh"]