#!/usr/bin/env bash

if [ "$(dpkg --print-architecture)" = "amd64" ]; then PLATFORM="amd64"; else PLATFORM="arm64"; fi
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$PLATFORM/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
kubectl version || command -V kubectl >/dev/null
