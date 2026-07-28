#!/usr/bin/env bash

while ! xhost +si:localuser:$( whoami ) ; do
  sleep 1
done
xhost +
exit 0
