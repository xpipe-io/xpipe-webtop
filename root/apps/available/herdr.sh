#!/usr/bin/env bash

if [ "$(dpkg --print-architecture)" = "amd64" ]; then PLATFORM="x86_64"; else PLATFORM="aarch64"; fi
curl -L -o herdr "https://github.com/herdrdev/herdr/releases/latest/download/herdr-linux-$PLATFORM"
sudo install -o root -g root -m 0755 herdr /usr/local/bin/herdr
rm herdr
herdr --version
