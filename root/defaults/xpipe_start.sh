#!/bin/bash

. /defaults/environment.sh

nohup /opt/$XPIPE_PACKAGE/bin/xpiped </dev/null &>/dev/null & disown
