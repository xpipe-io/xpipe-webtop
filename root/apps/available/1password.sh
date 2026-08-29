#!/usr/bin/env bash

curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
if [ "$(dpkg --print-architecture)" = "amd64" ]; then PLATFORM="amd64"; else PLATFORM="arm64"; fi
echo "deb [arch=$PLATFORM signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$PLATFORM stable main" | sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt update && sudo apt install -y 1password 1password-cli

sudo mv /usr/bin/1password /usr/bin/1password-sandbox
echo -e '#!/bin/bash\n/usr/bin/1password-sandbox --no-sandbox "$@"' | sudo tee /usr/bin/1password
sudo chmod a+x /usr/bin/1password
sudo sed -i 's#Exec=/opt/1Password/1password#Exec=/usr/bin/1password#g' "/usr/share/applications/1password.desktop"

op --version
