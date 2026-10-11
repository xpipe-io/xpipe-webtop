#!/usr/bin/env bash

if [ "$(dpkg --print-architecture)" = "amd64" ]; then PLATFORM="x86_64"; SSM_PLATFORM="64bit"; else PLATFORM="aarch64"; SSM_PLATFORM="arm64"; fi
curl "https://awscli.amazonaws.com/awscli-exe-linux-$PLATFORM.zip" -o "/tmp/awscliv2.zip"
unzip "/tmp/awscliv2.zip" -d "/tmp"
sudo "/tmp/aws/install" --update
rm -rf "/tmp/aws" "/tmp/awscliv2.zip"

curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_$SSM_PLATFORM/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"
sudo dpkg -i "/tmp/session-manager-plugin.deb"
rm -f "/tmp/session-manager-plugin.deb"

aws --version