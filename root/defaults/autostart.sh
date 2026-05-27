#!/usr/bin/env bash

XPIPE_DESKTOP_FILE=$([ -f "/usr/share/applications/xpipe.desktop" ] && echo "xpipe.desktop" || echo "xpipe-ptb.desktop")
kwriteconfig6 --file $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc --group Containments \
  --group 2 --group Applets --group 5 --group Configuration --group General --key launchers \
  "applications:firefox.desktop,applications:org.kde.konsole.desktop,applications:code.desktop,applications:org.remmina.Remmina.desktop,applications:$XPIPE_DESKTOP_FILE"

plasma-apply-colorscheme BreezeDark
plasma-apply-desktoptheme breeze-dark
plasma-apply-lookandfeel -a io.xpipe.desktop
# plasma-apply-wallpaperimage /usr/share/wallpapers/Webtop/contents/images/3000x2000.png

xpipe open

exit 0
