FROM postgis/postgis:16-3.5-alpine

ENV USER=api
ENV GROUPNAME=$USER
ENV UID=1001
ENV GID=1002

# Install basic web server tools and create non-root user
RUN apk update && apk add \
    vim ucspi-tcp6 && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup --gid "$GID" "$GROUPNAME" && \
    adduser --disabled-password --ingroup "$GROUPNAME" --uid "$UID" $USER

# Change to non-root user and set working directory
USER $USER
WORKDIR /app

# Copy api scripts
COPY --chown=$USER:$USER --chmod=0500 ./api/api.sh .
COPY --chown=$USER:$USER --chmod=0500 ./api/gdsc_get_schema_tables.sh .
COPY --chown=$USER:$USER --chmod=0500 ./api/gdsc_load_variable.sh .
COPY --chown=$USER:$USER --chmod=0500 ./api/gdsc_get_loaded_variables_for_table.sh .
COPY --chown=$USER:$USER --chmod=0500 ./api/gdsc_path_and_dependencies.sh .

# copy the init script
COPY --chown=$USER:$USER --chmod=777 ./gaia-postgis/init.sh .

ENTRYPOINT ["/app/init.sh"]