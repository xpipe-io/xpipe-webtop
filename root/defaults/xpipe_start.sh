#!/bin/bash

. /defaults/environment.sh

nohup /opt/$XPIPE_PACKAGE/bin/xpiped & disown </dev/null >/dev/null 2>&1
