#!/usr/bin/env bash

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt update
sudo apt install -y wezterm
echo -e "local wezterm = require 'wezterm'\nlocal config = wezterm.config_builder()\nconfig.enable_wayland = false\nreturn config\n" >> .wezterm.lua
wezterm --version
