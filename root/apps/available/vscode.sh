#!/usr/bin/env bash

echo 'code code/add-microsoft-repo boolean true' | sudo debconf-set-selections
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
rm -f /tmp/packages.microsoft.gpg

sudo apt update
sudo apt install --no-install-recommends -qqy code

sudo mv /usr/bin/code /usr/bin/code-sandbox
echo -e '#!/bin/bash\nDONT_PROMPT_WSL_INSTALL=No_Prompt_please /usr/bin/code-sandbox --no-sandbox --user-data-dir=~/.vscode "$@"' | sudo tee /usr/bin/code
sudo chmod a+x /usr/bin/code
code --version
