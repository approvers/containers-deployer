#!/usr/bin/env sh

SSH_OPTIONS="StrictHostKeyChecking=no"
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
}

copy() {
    FROM=$1
    TO=$2
    RECURSIVE=$3

    if $RECURSIVE; then
        scp -o $SSH_OPTIONS -i ~/.ssh/identity -r -P ${SSH_PORT} $FROM $TO
    else
        scp -o $SSH_OPTIONS -i ~/.ssh/identity -P ${SSH_PORT} $FROM $TO
    fi
}

setup_directories
setup_ssh_key
copy /deploy.sh $SSH_HOST:~/.cdep/deploy.sh false
copy $SOURCE_DIRECTORY $SSH_HOST:~/.cdep/repo true
ssh -o $SSH_OPTIONS -i ~/.ssh/identity -p $SSH_PORT $SSH_USER@$SSH_HOST ~/.cdep/deploy.sh
