#!/bin/bash

# Check if data volume already exists, and if not, initialise it with default values
if [ ! -z "$(docker volume ls | grep 'dst_data')" ]
then
    docker volume create dst_data
    cp -R MyDediServer* /var/lib/docker/volume/dst_data/_data
    sudo chown -R 1000:1000 /var/lib/docker/volume/dst_data/_data/*
fi

# Run the dedicated server
docker-compose up -d