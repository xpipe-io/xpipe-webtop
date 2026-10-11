#!/usr/bin/env bash

curl -L "https://bitwarden.com/download/?app=desktop&platform=linux&variant=deb" -o bw.deb
sudo apt install -y ./bw.deb
rm bw.deb
sudo rm -f /usr/bin/bitwarden
echo -e '#!/bin/bash\n/opt/Bitwarden/bitwarden --no-sandbox "$@"' | sudo tee /usr/bin/bitwarden
sudo chmod a+x /usr/bin/bitwarden
sudo sed -i 's#Exec=/opt/Bitwarden/bitwarden#Exec=/usr/bin/bitwarden#g' "/usr/share/applications/bitwarden.desktop"

curl -L "https://bitwarden.com/download/?app=cli&platform=linux" -o bw-cli.zip
unzip bw-cli.zip
sudo install -o root -g root -m 0755 bw /usr/local/bin/bw
rm bw bw-cli.zip
bw --version
