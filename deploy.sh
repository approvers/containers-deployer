#!/usr/bin/sh

cd ~/.cdep/repo

for DIRECTORY in */; do
    echo $DIRECTORY
    cd $DIRECTORY

    if [ -f "./.env" ]; then
        docker-compose --env-file ./.env up -d
    else
        docker-compose up -d
    fi

    cd ..
done
