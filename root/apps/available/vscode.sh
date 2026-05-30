#!/usr/bin/env bash

if [ "$TARGETPLATFORM" = "linux/amd64" ]; then VSCODE_LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; else VSCODE_LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"; fi
wget -O vscode.deb "${VSCODE_LINK}"
DEBIAN_FRONTEND=noninteractive \
apt-get update
apt-get install --no-install-recommends -y "./vscode.deb"
rm "./vscode.deb"

mv /usr/share/code/code /usr/share/code/code-sandbox
echo '#!/bin/bash\n/usr/share/code/code-sandbox --no-sandbox "$@"' > /usr/share/code/code
chmod +x /usr/share/code/code
sudo ln -sf /usr/share/code/code /usr/bin/code
