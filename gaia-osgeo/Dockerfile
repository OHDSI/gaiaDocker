FROM ghcr.io/osgeo/gdal:ubuntu-full-latest

ENV USER=api
ENV GROUPNAME=$USER
ENV UID=1001

# Install basic web server tools and create non-root user
RUN apt-get update && apt-get install -y \
    vim ucspi-tcp && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -u "$UID" $USER

# Change to non-root user and set working directory
USER $USER
WORKDIR /app

# Copy api script
COPY --chown=$USER:$USER --chmod=0500 ./api/api.sh .