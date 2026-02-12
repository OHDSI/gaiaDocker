FROM alpine:latest AS shell-installer

FROM postgrest/postgrest:latest

COPY --from=shell-installer /bin/sh /bin/sh
COPY --from=shell-installer /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=shell-installer /bin/cat /bin/cat
COPY --from=shell-installer /bin/ls /bin/ls

# copy the init script
USER root
COPY --chmod=777 ./gaia-postgrest/init.sh /init.sh

# run as 1000
USER 1000
CMD ["/bin/sh","/init.sh"]