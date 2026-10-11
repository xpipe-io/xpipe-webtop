#!/usr/bin/env bash

sudo curl https://apt.releases.teleport.dev/gpg -o /etc/apt/keyrings/teleport-archive-keyring.asc
. /etc/os-release
echo "deb [signed-by=/etc/apt/keyrings/teleport-archive-keyring.asc] https://apt.releases.teleport.dev/${ID?} ${VERSION_CODENAME?} stable/v17" | sudo tee /etc/apt/sources.list.d/teleport.list > /dev/null
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install teleport
tsh version
