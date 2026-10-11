#!/usr/bin/env bash

if [ "$(dpkg --print-architecture)" = "amd64" ]; then PLATFORM="amd64"; else PLATFORM="arm64"; fi
curl -sSLO https://github.com/hetznercloud/cli/releases/latest/download/hcloud-linux-$PLATFORM.tar.gz
sudo tar -C /usr/local/bin --no-same-owner -xzf hcloud-linux-$PLATFORM.tar.gz hcloud
rm hcloud-linux-$PLATFORM.tar.gz

hcloud version