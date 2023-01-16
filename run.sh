#!/bin/bash
# linux-dev run.sh

show_help() {
  cat 1>&2 <<EOF
Usage: ./run HOST_DIR [OPTIONS] [ARGS]
HOST_DIR: The host directory to mount inside the container
OPTIONS:
  -h, --help        Show this help message
  -x, --x11         Enable X11 (defaults to false)
  -n, --name cname  Set the container name to cname (defaults to the base directory in the HOST_DIR path)
  --                End of options
ARGS: Additional arguments to pass to docker
EOF
}

main() {
  local X11=false
  local HOST_DIR=""
  local NAME=""
  local ARGS=""
  parse_args "$@"
  [ -z "$HOST_DIR" ] && show_help && exit 1

  USER="$(id -u -n)"
  BASENAME="$(basename $HOST_DIR)"
  WORK_DIR="/home/$USER/$BASENAME"
  [ -z "$NAME" ] && NAME=$BASENAME
  X11_PARAMS=""
  [ $X11 = true ] && X11_PARAMS="--env DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix"

  # if [ $X11 = true ]; then
  #     echo "X11 flag is set"
  # else
  #     echo "X11 flag is not set"
  # fi
  # echo "Host dir: $HOST_DIR"
  # echo "Container: $NAME"
  # echo "Args: $ARGS"

  sudo -E "$(which docker)" run -itd --restart=always --hostname "$NAME" --name "$NAME" --env HOST_DIR="$HOST_DIR" \
    -v "$HOST_DIR":"$WORK_DIR" -v /var/run/docker.sock:/var/run/docker.sock $X11_PARAMS $ARGS linux-dev /bin/bash --norc \
  || return 1
  
  echo "Container \"$NAME\" running with host directory \"$HOST_DIR\" mounted at \"$WORK_DIR\""
  return 0
}

parse_args() {
  while [ $# -gt 0 ]
  do
    case $1 in

    -h|--help)
      show_help && exit 0
      ;;

    -x|--x11)
      X11=true
      ;;

    -n|--name)
      [ $# -eq 1 ] || [ "${2#-*}" != "$2" ] && show_help && exit 1
      NAME="$2"
      shift
      ;;
    -n=*|--name=*)
      NAME="${1#*=}"
      ;;

    --)
      shift
      break
      ;;

    --*)
      ARGS="$ARGS $1"
      ;;

    *)
      if [ -z "$HOST_DIR" ]; then
          HOST_DIR="$1"
      else
          ARGS="$ARGS $1"
      fi
      ;;

    esac
    shift
  done
  ARGS="$ARGS $@"
}

main "$@"
