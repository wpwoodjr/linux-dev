#!/bin/bash
# linux-dev run.sh

[ -z "$1" ] && echo "Usage: ./run.sh \"HOST-WORKING-DIRECTORY\" [CONTAINER-NAME] [ADDITIONAL-ARGUMENTS]" && exit 1
HOST_DIR="$1"
shift 1

NAME="linux-dev"
[ ! -z "$1" ] && NAME="$1" && shift 1

USER="$(id -u -n)"
WORK_DIR="/home/$USER/work"

set -e

sudo -E "$(which docker)" run -itd --restart=always --hostname "$NAME" --name "$NAME" --env HOST_DIR="$HOST_DIR" \
  -v "$HOST_DIR":"$WORK_DIR" -v /var/run/docker.sock:/var/run/docker.sock $@ linux-dev

echo "Container \"$NAME\" running with host directory \"$HOST_DIR\" mounted at \"$WORK_DIR\""
