
FROM alpine:latest AS shell-installer

FROM postgrest/postgrest:latest AS base

FROM base AS build-arm64
COPY --from=shell-installer /bin/sh /bin/sh
COPY --from=shell-installer /lib/ld-musl-aarch64.so.1 /lib/
COPY --from=shell-installer /bin/cat /bin/cat
COPY --from=shell-installer /bin/ls /bin/ls

FROM base AS build-amd64
COPY --from=shell-installer /bin/sh /bin/sh
COPY --from=shell-installer /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=shell-installer /bin/cat /bin/cat
COPY --from=shell-installer /bin/ls /bin/ls

FROM build-${TARGETARCH} AS final

# copy the init script
COPY --chmod=777 ./gaia-postgrest/init.sh /init.sh

# run as 1000 - default for postgrest alpine
USER 1000
CMD ["/bin/sh","/init.sh"]