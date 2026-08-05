#!/usr/bin/env bash

sudo mkdir -p /apps/installed
sudo chmod 777 /apps/installed

FORCE=0
APPS="$@"
for APP in $@
do
    if [[ "$APP" == "--force" ]]; then
      FORCE=1
      continue
    fi

    INSTALLED_FILE="/apps/installed/$APP.sh"
    if [[ FORCE == 0 && -f $INSTALLED_FILE ]]; then
      echo "App $APP is already installed. Skipping ..."
      continue
    fi

    SCRIPT_FILE="/apps/available/$APP.sh"
    . $SCRIPT_FILE
    if [[ $? != 0 ]]; then
      echo "App $APP failed to install"
      exit 1;
    fi

    ln -s $SCRIPT_FILE $INSTALLED_FILE
    echo "Installed $APP"
    INSTALLED_DIR="$HOME/.xpipe/webtop/installed"
    mkdir -p "$INSTALLED_DIR"
    touch "$INSTALLED_DIR/$APP"
done