#!/usr/bin/env bash

sudo add-apt-repository -y ppa:phoerious/keepassxc
sudo apt update
sudo apt install -y keepassxc
mkdir -p "$HOME/.config/keepassxc"
echo -e "[General]\nConfigVersion=2\n\n[Browser]\nEnabled=true\nSearchInAllDatabases=true\n" > "$HOME/.config/keepassxc/keepassxc.ini"
sudo sed -i 's/Exec=keepassxc %f/Exec=keepassxc -platform xcb %f/g' "/usr/share/applications/org.keepassxc.KeePassXC.desktop"
keepassxc -platform offscreen --version
