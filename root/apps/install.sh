#!/usr/bin/env bash

set -e

ENV_FILE=/apps/env
export $(cat $ENV_FILE | xargs)
export DEBIAN_FRONTEND="noninteractive"

mkdir -p /apps/installed
chmod 777 /apps/installed

FORCE=0
APPS="$@"
for APP in "$APPS"
do
    if [ $APP == "--force" ]; then
      FORCE=1
    fi

    INSTALLED_FILE="/apps/installed/$APP.sh"
    if [ FORCE == 0 || -f $INSTALLED_FILE ]; then
      echo "App $APP is already installed. Skipping ..."
      continue
    fi

    SCRIPT_FILE="/apps/available/$APP.sh"
    . $SCRIPT_FILE
    ln -s $SCRIPT_FILE $INSTALLED_FILE
    echo "Installed $APP"
done