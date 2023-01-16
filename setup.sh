#!/bin/bash
# linux-dev setup.sh

# registers a tool as installed
installed_tools="$HOME/.linux-dev/installed-tools"
register_installed() {
    echo -e "\n===========> installing $1..."
    [ "$EUID" -ne 0 ] && grep -s -q "^$1$" "$installed_tools" || echo "$1" >>"$installed_tools"
}

register_installed "utility scripts"
for f in "install-tools" "merge-kubeconfig" "az-get-credentials"; do
  sudo cp "source/$f" /usr/local/bin
  sudo chmod 0755 "/usr/local/bin/$f"
  # sed command converts Windows (CR LF) to Unix (LF) line endings
  sudo sed -i 's/\r$//' "/usr/local/bin/$f"
  ls -l "/usr/local/bin/$f"
done
grep -s -q "### linux-dev ###" ~/.bashrc || echo -e "\n### linux-dev ###\nalias update-tools=\"install-tools upgrade\"" >>~/.bashrc

install-tools init base $@

echo -e "\n===========> finished setup\numask is $(umask -S)\nlocale is $LANG"
