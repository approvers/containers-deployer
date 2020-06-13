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
    echo "$SSH_KEY" > ./identity
    chmod 600 ./identity
}

setup_directories
setup_ssh_key

cat - << EOS > ./config
Host $SSH_HOST
    User $SSH_USER
    Port $SSH_PORT
    IdentityFile ./identity
    StrictHostKeyChecking no
EOS

rsync -a -v -e "ssh -F ./config" /deploy.sh "$SSH_HOST:~/.cdep/"
rsync -a -v -e "ssh -F ./config" --delete "$SOURCE_DIRECTORY/" "$SSH_HOST:~/.cdep/repo/"
ssh -F ./config $SSH_HOST "~/.cdep/deploy.sh"
