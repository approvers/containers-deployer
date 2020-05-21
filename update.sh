#!/usr/bin/sh

cd ~/.cdep/repo

for DIRECTORY in */; do
    echo $DIRECTORY
    docker-compose up -d
done
