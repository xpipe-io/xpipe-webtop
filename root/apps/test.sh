#!/usr/bin/env bash

set -e
set -x
export PATH="$HOME/.local/bin:$PATH"

USER_HOME="$HOME"
sudo chown -R abc "$USER_HOME"
sudo chgrp -R abc "$USER_HOME"

cd "$HOME"

if [ -z "$1" ]; then
  exclude=("/apps/available/aws.sh")
  for file in /apps/available/*; do
      printf '%s\0' "${exclude[@]}" | grep -F -x -z -- "$file" && continue
      name=$(basename $file .sh)
      /apps/install.sh $name
  done
else
  /apps/install.sh "$1"
fi
