#!/usr/bin/env bash

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt update
DEBIAN_FRONTEND=noninteractive sudo apt install -y tailscale
tailscale --version

sudo touch "/etc/s6-overlay/s6-rc.d/user/contents.d/tailscaled"
