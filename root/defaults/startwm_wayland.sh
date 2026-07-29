#!/bin/bash

. /defaults/setup.sh

# Export variables globally so all children inherit them
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_TYPE=wayland
export KDE_SESSION_VERSION=6
export DISPLAY=:1
export ZED_ALLOW_EMULATED_GPU=1
export ELECTRON_OZONE_PLATFORM_HINT=auto

sudo mkdir -p /tmp/.X11-unix
sudo chmod 1777 /tmp/.X11-unix

dbus-run-session bash -l -c '
    WAYLAND_DISPLAY=wayland-1 python3 /kwin-xwayland.py &
    KWIN_PID=$!
    sleep 2

    /usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1

    # The autostart scripts are not run by KDE, so we have to do it manually
    nohup bash /defaults/autostart.sh &> $HOME/webtop-autostart.log & disown

    WAYLAND_DISPLAY=wayland-0 plasmashell
    kill $KWIN_PID
' > /dev/null 2>&1

sleep 5
