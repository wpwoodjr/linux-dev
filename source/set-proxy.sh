#!/bin/bash
# linux-dev set-proxy.sh

uriencode() {
  s="${1//'%'/%25}"
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

if [ -z "$1" ]
then
  echo "Usage: set-proxy USERNAME [PASSWORD]"
else
  pwd="$2"
  [ -z "$pwd" ] && IFS= read -s -p "Proxy password: " pwd && echo
  pwd=$(uriencode "$pwd")

  proxy="http://$1:$pwd@nodecrypt.corp.com:800"
  noproxy="localhost,127.0.0.1,.docker.internal,.corp.com,.corp2.com"

  export http_proxy="$proxy"
  export https_proxy="$proxy"
  export HTTP_PROXY="$proxy"
  export HTTPS_PROXY="$proxy"
  export FTP_PROXY="$proxy"
  export ftp_proxy="$proxy"
  export no_proxy="$noproxy"
  export NO_PROXY="$noproxy"

  echo "Acquire { HTTP::proxy \"$http_proxy\"; HTTPS::proxy \"$https_proxy\"; }" >/tmp/proxy.conf \
  && chmod a-rwx /tmp/proxy.conf \
  && sudo chown 0 /tmp/proxy.conf \
  && sudo chgrp 0 /tmp/proxy.conf \
  && sudo mv /tmp/proxy.conf /etc/apt/apt.conf.d/proxy.conf

  echo "Proxies set for user $1"
fi
