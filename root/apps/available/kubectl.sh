#!/usr/bin/env bash

if [ "$(dpkg --print-architecture)" = "amd64" ]; then KUBECTL_LINK="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; else KUBECTL_LINK="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"; fi
curl -LO "${KUBECTL_LINK}"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
kubectl version || command -V kubectl >/dev/null
