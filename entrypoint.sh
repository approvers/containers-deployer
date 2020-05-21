#!/usr/bin/env sh

SSH_HOST = ${INPUT_SSH-HOST}
SSH_PORT = ${INPUT_SSH-PORT}
SSH_USER = ${INPUT_SSH-USER}
SSH_KEY = ${INPUT_SSH-KEY}
SOURCE_DIRECTORY = $GITHUB_WORKSPACE

setup_directories() {
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
}

setup_ssh_key() {
    cat - >> ~/.ssh/identity <<< $SSH_KEY
    chmod 600 ~/.ssh/identity
    ssh-keyscan -H $SSH_HOST >> ~/.ssh/known_hosts
}

copy() {
    FROM = $1
    TO = $2
    RECURSIVE = $3

    if $RECURSIVE; then
        scp -i ~/.ssh/identity -P $SSH_PORT
    else
        scp -i ~/.ssh/identity -P $SSH_POST -r $FROM $TO
    fi
}

copy ./deploy.sh ~/.cdep/deploy.sh false
copy $SOURCE_DIRECTORY ~/.cdep/repo true
ssh -p $SSH_PORT $SSH_USER@$SSH_HOST ~/.cdep/deploy.sh
