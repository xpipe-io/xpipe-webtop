#!/usr/bin/env bash

# Wait for display to be initialized
while ! xhost +si:localuser:$( whoami ) ; do
  sleep 1
done

sleep 3

MOBILE_FILE="$HOME/.xpipe/webtop/mobile"
if [ -f $MOBILE_FILE ]; then
  /defaults/mobile.sh
else
  /defaults/desktop.sh
fi

STATE_FILE="$HOME/.initialized"
if [ ! -f $STATE_FILE ]; then
  touch $STATE_FILE

  # Fix taskmanager bar
  XPIPE_DESKTOP_FILE=$([ -f "/usr/share/applications/xpipe-ptb.desktop" ] && echo "xpipe-ptb.desktop" || echo "xpipe.desktop")
  kwriteconfig6 --file $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc --group Containments \
    --group 2 --group Applets --group 5 --group Configuration --group General --key launchers \
    "applications:systemsettings.desktop,applications:org.kde.dolphin.desktop,applications:firefox.desktop,applications:org.kde.konsole.desktop,applications:org.kde.kate.desktop,applications:$XPIPE_DESKTOP_FILE"

  # Update theme
  plasma-apply-colorscheme BreezeDark
  plasma-apply-desktoptheme breeze-dark
  # plasma-apply-lookandfeel -a io.xpipe.desktop
  # plasma-apply-wallpaperimage /usr/share/wallpapers/Webtop/contents/images/3000x2000.png

  sleep 1

  # Reload changes
  plasmashell --replace

  while ! xhost +si:localuser:$( whoami ) ; do
    sleep 1
  done

  nohup alacritty -e bash -c "/defaults/xpipe_install.sh && xpipe open" & disown >/dev/null 2>&1
else
  xpipe open
fi

exit 0
