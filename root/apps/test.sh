#!/usr/bin/env bash

set -e
set -x
export PATH="$HOME/.local/bin:$PATH"

USER_HOME="$HOME"
sudo chown -R abc "$USER_HOME"
sudo chgrp -R abc "$USER_HOME"

cd "$HOME"

if [ -z "$1" ]; then
  for file in /apps/available/*; do
      name=$(basename $file .sh)
      /apps/install.sh $name
  done
else
  /apps/install.sh "$1"
fi