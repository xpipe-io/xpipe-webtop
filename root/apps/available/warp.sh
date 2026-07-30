#!/usr/bin/env bash
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
if [ "$(dpkg --print-architecture)" = "amd64" ]; then PLATFORM="amd64"; else PLATFORM="arm64"; fi
sudo sh -c "echo \"deb [arch=$PLATFORM signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main\" > /etc/apt/sources.list.d/warpdotdev.list"
rm warpdotdev.gpg
sudo apt update && sudo apt install -y warp-terminal
warp-terminal --help
