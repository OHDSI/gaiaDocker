FROM python:3.10-alpine

ENV USER=gdsc
ENV GROUPNAME=$USER
ENV UID=1001
ENV GID=1002

# Install basic web server, other necessary tools and create non-root user
RUN apk update && \
    apk add --no-cache --update-cache hdf5-dev netcdf-dev libc-dev && \
    apk add vim gcc && \
    apk add ucspi-tcp6 && \
    rm -rf /var/lib/apt/lists/* && \
      addgroup --gid "$GID" "$GROUPNAME" && \
    adduser --disabled-password --ingroup "$GROUPNAME" --uid "$UID" $USER

USER $USER
WORKDIR /home/$USER

COPY ./gaia-gdsc/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app

# Copy api script
COPY --chown=$USER:$USER --chmod=0500 ./api/api.sh .

# copy the init script
COPY --chown=$USER:$USER --chmod=777 ./gaia-gdsc/init.sh .

ENTRYPOINT ./init.sh