#!/usr/bin/env bash

wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
  | sudo tee /etc/apt/sources.list.d/vscodium.sources

sudo apt update && sudo apt install codium

sudo mv /usr/bin/codium /usr/bin/codium-sandbox
echo -e '#!/bin/bash\nDONT_PROMPT_WSL_INSTALL=No_Prompt_please /usr/bin/codium-sandbox --no-sandbox --user-data-dir=~/.vscodium "$@"' | sudo tee /usr/bin/codium
sudo chmod a+x /usr/bin/codium
codium --version

codium --version
