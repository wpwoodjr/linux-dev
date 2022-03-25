#!/bin/bash
# linux-dev no-proxy.sh

unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY
unset FTP_PROXY
unset ftp_proxy
unset no_proxy
unset NO_PROXY

sudo rm -f /etc/apt/apt.conf.d/proxy.conf
