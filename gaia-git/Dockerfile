FROM alpine/git

ENV USER=gaia
ENV GROUPNAME=$USER
ENV UID=1001
ENV GID=1002

# Install basic web server, other necessary tools and create non-root user
RUN apk update && \
    apk add vim ucspi-tcp6 && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup --gid "$GID" "$GROUPNAME" && \
    adduser --disabled-password --ingroup "$GROUPNAME" --uid "$UID" $USER

USER $USER
WORKDIR /app

# Copy api script
COPY --chown=$USER:$USER --chmod=0500 ./api/api.sh .

# copy the init script
COPY --chown=$USER:$USER --chmod=777 ./gaia-git/init.sh .

ENTRYPOINT ./init.sh