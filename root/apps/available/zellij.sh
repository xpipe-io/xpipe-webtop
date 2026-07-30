#!/usr/bin/env bash

if [ "$(dpkg --print-architecture)" = "amd64" ]; then ZELLIJ_LINK="https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"; else ZELLIJ_LINK="https://github.com/zellij-org/zellij/releases/latest/download/zellij-aarch64-unknown-linux-musl.tar.gz"; fi
curl -LO "${ZELLIJ_LINK}"
tar -xvf zellij*.tar.gz
sudo install -o root -g root -m 0755 zellij /usr/local/bin/zellij
rm zellij
rm zellij*.tar.gz
zellij --version
