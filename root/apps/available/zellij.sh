#!/usr/bin/env bash

if [ "$(dpkg --print-architecture)" = "amd64" ]; then PLATFORM="x86_64"; else PLATFORM="aarch64"; fi
curl -LO "https://github.com/zellij-org/zellij/releases/latest/download/zellij-$PLATFORM-unknown-linux-musl.tar.gz"
tar -xvf "zellij-$PLATFORM-unknown-linux-musl.tar.gz"
sudo install -o root -g root -m 0755 zellij /usr/local/bin/zellij
rm zellij
rm "zellij-$PLATFORM-unknown-linux-musl.tar.gz"
zellij --version
