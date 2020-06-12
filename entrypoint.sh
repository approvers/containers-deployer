#!/usr/bin/env sh

SSH_HOST=${INPUT_SSH_HOST}
SSH_PORT=${INPUT_SSH_PORT}
SSH_USER=${INPUT_SSH_USER}
SSH_KEY=${INPUT_SSH_KEY}
SOURCE_DIRECTORY=${GITHUB_WORKSPACE}

setup_directories() {
    mkdir -p ~/.cdep/repo
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
}

setup_ssh_key() {
    echo "$SSH_KEY" > ~/.ssh/identity
    chmod 600 ~/.ssh/identity
    ssh-keyscan -H $SSH_HOST >> ~/.ssh/known_hosts
    ssh-keyscan -H $(dig +short A $SSH_HOST) >> ~/.ssh/known_hosts
    ssh-keyscan -H $(dig +short AAAA $SSH_HOST) >> ~/.ssh/known_hosts
}

copy() {
    FROM=$1
    TO=$2
    RECURSIVE=$3

    if $RECURSIVE; then
        scp -i ~/.ssh/identity -P ${SSH_PORT} -r $FROM $TO
    else
        scp -i ~/.ssh/identity -P ${SSH_PORT} $FROM $TO
    fi
}

setup_directories
setup_ssh_key
copy /deploy.sh ~/.cdep/deploy.sh false
copy $SOURCE_DIRECTORY ~/.cdep/repo true
ssh -i ~/.ssh/identity -p $SSH_PORT $SSH_USER@$SSH_HOST ~/.cdep/deploy.sh
