#!/usr/bin/env bash

sudo apt install -y python3 python3-pip
python3 -m venv keeper-env
source keeper-env/bin/activate
pip install keepercommander
sudo ln -s /config/keeper-env/bin/keeper /config/.local/bin/keeper
keeper --version
