#!/bin/bash
# linux-dev build.sh

image="linux-dev"
_USER="$(id -u -n)"
_UID="$(id -u)"
_GROUP="$(id -g -n)"
_GID="$(id -g)"
HOME_DIR="/home/$_USER"
DOCKER_GID="$(cat /etc/group | grep docker | cut -d: -f3)"

if [ "$1" = "--noproxy" ]
then
  shift 1
  echo "Building docker container..."
  sudo -E docker build --tag "$image" source \
    --progress plain \
    --build-arg USER="$_USER" \
    --build-arg HOME_DIR="$HOME_DIR" \
    --build-arg UID="$_UID" \
    --build-arg GROUP="$_GROUP" \
    --build-arg GID="$_GID" \
    --build-arg DOCKER_GID="$DOCKER_GID" \
    --build-arg TERM="$TERM" \
    $@
else
  uname="$1"
  [ -z "$uname" ] && echo -e "Usage: ./build.sh USERNAME ['PASSWORD']\n   or: ./build.sh --noproxy" && exit
  shift 1
  pwd="$1"
  [ ! -z "$pwd" ] && shift 1
  [ -z "$pwd" ] && IFS= read -s -p "Proxy password: " pwd && echo

  # All special characters in password must be escaped with a backslash (\) character, for example: pa$$word would be pa\$\$word
  uriencode() {
    s="${pwd//'%'/%25}"
    s="${s//' '/%20}"
    s="${s//'!'/%21}"
    s="${s//'"'/%22}"
    s="${s//'#'/%23}"
    s="${s//'$'/%24}"
    s="${s//'&'/%26}"
    s="${s//"'"/%27}"
    s="${s//"("/%28}"
    s="${s//")"/%29}"
    s="${s//'*'/%2A}"
    s="${s//'+'/%2B}"
    s="${s//','/%2C}"
    s="${s//'/'/%2F}"
    s="${s//':'/%3A}"
    s="${s//';'/%3B}"
    s="${s//'='/%3D}"
    s="${s//'<'/%3C}"
    s="${s//'>'/%3E}"
    s="${s//'?'/%3F}"
    s="${s//'@'/%40}"
    s="${s//'['/%5B}"
    s="${s//']'/%5D}"
    s="${s//"\\"/%5C}"
    s="${s//'^'/%5E}"
    s="${s//"\`"/%60}"
    s="${s//'{'/%7B}"
    s="${s//'}'/%7D}"
    s="${s//'~'/%7E}"
    s="${s//'|'/%7C}"
    printf %s "$s"
  }
  pwd=$(uriencode "$pwd")

  proxy="http://$uname:$pwd@nodecrypt.corp.com:800"
  noproxy="localhost,127.0.0.1,.corp.com,.corp2.com"

  echo "Building docker container..."
  sudo -E docker build --tag "$image" source \
    --progress plain \
    --build-arg USER="$_USER" \
    --build-arg HOME_DIR="$HOME_DIR" \
    --build-arg UID="$_UID" \
    --build-arg GROUP="$_GROUP" \
    --build-arg GID="$_GID" \
    --build-arg DOCKER_GID="$DOCKER_GID" \
    --build-arg TERM="$TERM" \
    --build-arg http_proxy="$proxy" \
    --build-arg HTTP_PROXY="$proxy" \
    --build-arg https_proxy="$proxy" \
    --build-arg HTTPS_PROXY="$proxy" \
    --build-arg ftp_proxy="$proxy" \
    --build-arg FTP_PROXY="$proxy" \
    --build-arg no_proxy="$noproxy" \
    --build-arg NO_PROXY="$noproxy" \
    $@
fi
