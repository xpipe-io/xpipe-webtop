#!/usr/bin/env bash

sudo mkdir -p /apps/installed
sudo chmod 777 /apps/installed

FORCE=0
for APP in "$@"
do
    if [[ "$APP" == "--force" ]]; then
      FORCE=1
    fi
done

for APP in "$@"
do
    if [[ "$APP" == "--force" ]]; then
      continue
    fi

    INSTALLED_FILE="/apps/installed/$APP.sh"
    if [[ $FORCE == 0 && -f "$INSTALLED_FILE" ]]; then
      echo "App $APP is already installed. Skipping ..."
      continue
    fi

    SCRIPT_FILE="/apps/available/$APP.sh"
    if [[ ! -f "$SCRIPT_FILE" ]]; then
      echo "App $APP is not available"
      exit 1
    fi

    # Run in a separate shell that aborts on the first failing command
    if ! bash -e "$SCRIPT_FILE"; then
      echo "App $APP failed to install"
      exit 1
    fi

    ln -sf "$SCRIPT_FILE" "$INSTALLED_FILE"
    echo "Installed $APP"
    INSTALLED_DIR="$HOME/.xpipe/webtop/installed"
    mkdir -p "$INSTALLED_DIR"
    touch "$INSTALLED_DIR/$APP"
done
