#!/usr/bin/env bash

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip "/tmp/awscliv2.zip" -d "/tmp"
sudo "/tmp/aws/install"
rm -rf "/tmp/aws" "/tmp/awscliv2.zip"

if [ "$TARGETPLATFORM" = "linux/amd64" ]; then SSM_LINK="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"; else SSM_LINK="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb"; fi
curl "${SSM_LINK}" -o "/tmp/session-manager-plugin.deb"
sudo dpkg -i "/tmp/session-manager-plugin.deb"
rm -rf "/tmp/aws" "/tmp/session-manager-plugin.deb"