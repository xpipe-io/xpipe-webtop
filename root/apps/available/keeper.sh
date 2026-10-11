#!/usr/bin/env bash

sudo apt install -y python3 python3-pip
python3 -m venv "$HOME/keeper-env"
source "$HOME/keeper-env/bin/activate"
pip install keepercommander
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
ln -sf "$HOME/keeper-env/bin/keeper" "$HOME/.local/bin/keeper"
keeper --version
