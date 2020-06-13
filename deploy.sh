#!/usr/bin/sh

cd ~/.cdep/repo

for DIRECTORY in */; do
    echo $DIRECTORY
    cd $DIRECTORY
    docker-compose up -d
done
