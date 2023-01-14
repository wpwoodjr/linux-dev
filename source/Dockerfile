# linux-dev Dockerfile
# linux-dev comes pre-loaded with:
#  * optional self-signed certificates
#  * kubectl with krew plugin, docker, helm 3, az (azure cli), k9s, kafkacat, kpt, kustomize
#  * utilities including git, curl, wget, ping, jq, htop, nano, vim, less, ssh
#

ARG UBUNTU_VERSION="22.04"
FROM ubuntu:${UBUNTU_VERSION}
ARG USER UID GROUP GID DOCKER_GID HOME_DIR \
  TERM="xterm-256color" \
  USER_TOOLS="docker-ce-cli"
#  USER_TOOLS="docker-ce-cli kubectl azure-cli kafkacat krew helm3 kpt kustomize k9s"

# # add self-signed certs
# ADD ./certs.tar /usr/local/share/ca-certificates/

# copy utilities
#   install-tools - install and update tools
#   docker - script to run docker with proxy environment set
#   set-proxy.sh - script to set proxy settings
#   no-proxy.sh - script to unset proxy settings
#   merge-kubeconfig - script to merge kubeconfig files
#   az-get-credentials - script to get Azure AKS credentials
COPY install-tools docker set-proxy.sh no-proxy.sh merge-kubeconfig az-get-credentials /usr/local/bin/

# install utilities, init and create $USER
#   sed command converts Windows (CR LF) to Unix (LF) line endings
RUN echo "\n===========> installing utility tools..." \
&& for f in $(ls "/usr/local/bin"); do chmod a+rx-w "/usr/local/bin/$f" && sed -i 's/\r$//' "/usr/local/bin/$f" && echo "$f"; done \
&& /usr/local/bin/install-tools init user

USER "$USER"
WORKDIR "$HOME_DIR"
ENV TERM=$TERM

# copy help.txt, bashrc, init
COPY --chown=$USER:$GROUP help.txt bashrc init "$HOME_DIR"/

# install base, locale, and user tools; configure git, help.txt, .bashrc, and init
RUN /usr/local/bin/install-tools base locale $USER_TOOLS \
&& echo "\n===========> configuring git, help text, .bashrc, and init..." \
&& git config --global http.proxyAuthMethod 'basic' \
&& sed -i 's/\r$//' "$HOME_DIR/help.txt" \
&& chmod 644 "$HOME_DIR/help.txt" \
&& sed -i 's/\r$//' "$HOME_DIR/bashrc" \
&& cat "$HOME_DIR/bashrc" >>"$HOME_DIR/.bashrc" \
&& rm "$HOME_DIR/bashrc" \
&& sed -i 's/\r$//' "$HOME_DIR/init" \
&& chmod 755 "$HOME_DIR/init"
