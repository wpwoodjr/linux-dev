#!/bin/bash
# linux-dev setup.sh

# set umask
echo -e "\n===========> setting umask to u=rwx,g=rx,o=rx..."
umask u=rwx,g=rx,o=rx

# install utilities, init, base
echo -e "\n===========> installing utility tools..."
sudo cp source/install-tools source/merge-kubeconfig source/az-get-credentials /usr/local/bin/
for f in "install-tools" "merge-kubeconfig" "az-get-credentials"; do
  sudo chmod a+rx-w "/usr/local/bin/$f"
  # sed command converts Windows (CR LF) to Unix (LF) line endings
  sudo sed -i 's/\r$//' "/usr/local/bin/$f"
  ls -l "/usr/local/bin/$f"
done
install-tools init base $@
