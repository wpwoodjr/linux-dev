# linux-dev Dockerfile
ARG UBUNTU_VERSION="20.04"
FROM ubuntu:${UBUNTU_VERSION}

# The image comes pre-loaded with:
#  * optional self-signed certificates
#  * kubectl with krew plugin, docker, helm 3, az (azure cli), k9s, kafkacat, kpt, kustomize
#  * utilities including git, curl, wget, ping, jq, htop, nano, vim, less, ssh
#

ARG DEBIAN_FRONTEND="noninteractive"
# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
#RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes
# set up apt proxy (needed if using decrypting proxy; prevents OCSP validation errors)
#RUN echo "Acquire { https::Verify-Peer false }" >>/etc/apt/apt.conf.d/99verify-peer.conf

# # add self-signed certs
# ADD ./certs.tar /usr/local/share/ca-certificates/

# copy utilities
#   update-tools - install and update utility tools
#   docker - script to run docker with proxy environment set
#   set-proxy.sh - script to set proxy settings
#   no-proxy.sh - script to unset proxy settings
#   merge-kubeconfig - script to merge kubeconfig files
#   az-get-credentials - script to get Azure AKS credentials
COPY update-tools docker set-proxy.sh no-proxy.sh merge-kubeconfig az-get-credentials /usr/local/bin/

# upgrade existing and install base set of utilities/packages; create $USER
ARG USER
ARG UID
ARG GROUP
ARG GID
ARG DOCKER_GID
ARG HOME_DIR
ARG TERM="xterm-256color"

#   sed command converts Windows (CR LF) to Unix (LF) line endings
RUN echo "\n===========> installing utilities..." \
&& for f in $(ls /usr/local/bin); do chmod a+rx-w /usr/local/bin/"$f" && sed -i 's/\r$//' /usr/local/bin/"$f" && echo "$f"; done \
&& /usr/local/bin/update-tools base

USER "$USER"
WORKDIR "$HOME_DIR/work"
ENV TERM=$TERM

# copy help.txt, bashrc
COPY --chown=$USER:$GROUP help.txt bashrc "$HOME_DIR"/

# configure git, help.txt, and .bashrc; install k9s, helm 3, krew, kpt, kustomize as $USER
RUN echo "\n===========> configuring git, help text, and .bashrc..." \
&& git config --global http.proxyAuthMethod 'basic' \
&& sed -i 's/\r$//' "$HOME_DIR/help.txt" \
&& chmod 644 "$HOME_DIR/help.txt" \
&& sed -i 's/\r$//' "$HOME_DIR/bashrc" \
&& cat "$HOME_DIR/bashrc" >>"$HOME_DIR/.bashrc" \
&& rm "$HOME_DIR/bashrc" \
&& /usr/local/bin/update-tools install
