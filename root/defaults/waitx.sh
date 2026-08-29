#!/usr/bin/env bash

while ! xhost +si:localuser:$( whoami ) ; do
  sleep 1
done
xhost +
sleep 1
exit 0
