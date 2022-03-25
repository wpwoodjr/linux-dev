#!/bin/bash
# linux-dev run.sh

[ -z "$1" ] && echo "Usage: ./run.sh \"HOST-WORKING-DIRECTORY\" [CONTAINER-NAME]" && exit

USER="$(id -u -n)"
WORK_DIR="/home/$USER/work"
NAME="${2:-linux-dev}"

set -e

sudo -E docker run -itd --restart=always --hostname "$NAME" --name "$NAME" --env HOST_DIR="$1" -v "$1":"$WORK_DIR" -v /var/run/docker.sock:/var/run/docker.sock linux-dev

echo "Container \"$NAME\" running with host directory \"$1\" mounted at \"$WORK_DIR\""
