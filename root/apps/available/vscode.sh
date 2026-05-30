#!/usr/bin/env bash

if [ "$TARGETPLATFORM" = "linux/amd64" ]; then VSCODE_LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; else VSCODE_LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"; fi
wget -O vscode.deb "${VSCODE_LINK}"
DEBIAN_FRONTEND=noninteractive \
sudo apt update
sudo apt install --no-install-recommends -y "./vscode.deb"
rm "./vscode.deb"

sudo mv /usr/bin/code /usr/bin/code-sandbox
echo -e '#!/bin/bash\nDONT_PROMPT_WSL_INSTALL=No_Prompt_please /usr/bin/code-sandbox --no-sandbox --user-data-dir=~/.vscode "$@"' | sudo tee /usr/bin/code
sudo chmod a+x /usr/bin/code
code --version
