#!/usr/bin/env bash

curl -L "https://bitwarden.com/download/?app=cli&platform=linux" -o bw.zip
unzip bw.zip
sudo install -o root -g root -m 0755 bw /usr/local/bin/bw
rm bw bw.zip
bw --version
