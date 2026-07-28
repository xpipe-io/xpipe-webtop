#!/usr/bin/env bash

# Wait for display to be initialized
/defaults/waitx.sh

sleep 3

MOBILE_FILE="$HOME/.xpipe/webtop/mobile"
if [ -f $MOBILE_FILE ]; then
  /defaults/mobile.sh
else
  /defaults/desktop.sh
fi

FIRST_INIT_FILE="$HOME/.first-init"
SECOND_INIT_FILE="$HOME/.second-init"
if [ ! -f $FIRST_INIT_FILE ]; then
  touch $FIRST_INIT_FILE

   if [[ -v SSH_KEY ]]; then
     mkdir -p "$HOME/.ssh"
    echo "$SSH_KEY" >> "$HOME/.ssh/authorized_keys"
   fi

  echo "fastfetch" >> $HOME/.bashrc

  # Fix taskmanager bar
  XPIPE_DESKTOP_FILE=$([[ $XPIPE_PACKAGE == "xpipe-ptb" ]] && echo "xpipe-ptb.desktop" || echo "xpipe.desktop")
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
  /defaults/reload.sh

  # Running this earlier breaks the desktop apps directory of KDE. Why?
  python3 -m pip install xpipe_api

  /defaults/waitx.sh
  exit 0
elif [[ ! -f $SECOND_INIT_FILE ]]; then
  # Do second init stuff ...
  touch $SECOND_INIT_FILE
fi

if command -V $XPIPE_PACKAGE; then
  $XPIPE_PACKAGE open
else
  nohup alacritty --hold -T "XPipe install" -e bash -c "/defaults/xpipe_install.sh && $XPIPE_PACKAGE open" </dev/null &>/dev/null & disown
fi

exit 0
