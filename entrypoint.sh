#!/usr/bin/env sh

SSH_HOST=${INPUT_SSH_HOST}
SSH_PORT=${INPUT_SSH_PORT}
SSH_USER=${INPUT_SSH_USER}
SSH_KEY=${INPUT_SSH_KEY}
SOURCE_DIRECTORY=${GITHUB_WORKSPACE}

SSH_DIR="$HOME/.ssh"
SSH_CONFIG="$SSH_DIR/config"
SSH_IDENTITY="$SSH_DIR/identity"
SSH_KNOWN_HOSTS="$SSH_DIR/known_hosts"

_ssh() {
    ssh -F "$SSH_CONFIG" "$@"
}

_rsync() {
    rsync -a -v -e "ssh -F $SSH_CONFIG" "$@"
}

mkdir -p "$SSH_DIR"
echo "$SSH_KEY" > $SSH_IDENTITY
chmod 600 $SSH_IDENTITY

cat - << EOS > $SSH_CONFIG
Host $SSH_HOST
    User $SSH_USER
    Port $SSH_PORT
    IdentityFile $SSH_IDENTITY
    UserKnownHostsFile $SSH_KNOWN_HOSTS
    StrictHostKeyChecking no
EOS

_ssh $SSH_HOST mkdir -p "~/.cdep/repo"
_rsync /deploy.sh "$SSH_HOST:~/.cdep/"
_rsync  --delete --exclude ".git" "$SOURCE_DIRECTORY/" "$SSH_HOST:~/.cdep/repo/"
_ssh $SSH_HOST "~/.cdep/deploy.sh"
