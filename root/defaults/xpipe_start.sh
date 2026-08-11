#!/bin/bash

. /defaults/environment.sh

nohup dbus-launch /etc/$XPIPE_PACKAGE/bin/xpiped & disown </dev/null >/dev/null 2>&1
