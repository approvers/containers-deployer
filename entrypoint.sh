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
SSH_COMMAND="ssh -F $SSH_CONFIG"
RSYNC_COMMAND="rsync -a -v -e \"$SSH_COMMAND\""

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

$SSH_COMMAND $SSH_HOST mkdir -p "~/.cdep/repo"
$RSYNC_COMMAND /deploy.sh "$SSH_HOST:~/.cdep/"
$RSYNC_COMMAND --delete --exclude ".git" "$SOURCE_DIRECTORY/" "$SSH_HOST:~/.cdep/repo/"
$SSH_COMMAND $SSH_HOST "~/.cdep/deploy.sh"
