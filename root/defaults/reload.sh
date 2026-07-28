#!/usr/bin/env bash

$XPIPE_PACKAGE daemon stop --wait
export QDBUS_DEBUG=1
qdbus6 org.kde.Shutdown /Shutdown org.kde.Shutdown.logout
exit 0
