#!/bin/bash

ulimit -c 0

# Disable compositing and screen locking
if [ ! -f $HOME/.config/kwinrc ]; then
  kwriteconfig6 --file $HOME/.config/kwinrc --group Compositing --key Enabled false
fi
if [ ! -f $HOME/.config/kscreenlockerrc ]; then
  kwriteconfig6 --file $HOME/.config/kscreenlockerrc --group Daemon --key Autolock false
fi
if [ ! -f $HOME/.config/kdeglobals ]; then
  kwriteconfig6 --file $HOME/.config/kdeglobals --group KScreen --key XwaylandClientScale false
fi

if [ ! -f "$HOME/.config/konsolerc" ]; then
  kwriteconfig6 --file $HOME/.config/konsolerc --group General --key ConfigVersion 1
  kwriteconfig6 --file $HOME/.config/konsolerc --group KonsoleWindow --key UseSingleInstance true
  kwriteconfig6 --file $HOME/.config/konsolerc --group "Notification Messages" --key CloseAllTabs true
  kwriteconfig6 --file $HOME/.config/konsolerc --group "Notification Messages" --key CloseSingleTab true
fi

if [ ! -f "$HOME/.config/kwalletrc" ]; then
  kwriteconfig6 --file $HOME/.config/kwalletrc --group Wallet --key Enabled false
fi

# Power related
setterm blank 0
setterm powerdown 0

# Setup permissive clipboard rules
KWIN_RULES_FILE="$HOME/.config/kwinrulesrc"
RULE_DESC="wl-clipboard support"
if ! grep -q "$RULE_DESC" "$KWIN_RULES_FILE" 2>/dev/null; then
  echo "Applying KWin clipboard rule..."
  if command -v uuidgen &> /dev/null; then
    RULE_ID=$(uuidgen)
  else
    RULE_ID=$(cat /proc/sys/kernel/random/uuid)
  fi
  count=$(kreadconfig6 --file "$KWIN_RULES_FILE" --group General --key count --default 0)
  new_count=$((count + 1))
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group General --key count "$new_count"
  existing_rules=$(kreadconfig6 --file "$KWIN_RULES_FILE" --group General --key rules)
  if [ -z "$existing_rules" ]; then
    kwriteconfig6 --file "$KWIN_RULES_FILE" --group General --key rules "$RULE_ID"
  else
    kwriteconfig6 --file "$KWIN_RULES_FILE" --group General --key rules "$existing_rules,$RULE_ID"
  fi
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key Description "$RULE_DESC"
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key wmclass "wl-(copy|paste)"
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key wmclassmatch 3
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key skiptaskbar --type bool "true"
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key skiptaskbarrule 2
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key skipswitcher --type bool "true"
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key skipswitcherrule 2
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key fsplevel 3
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key fsplevelrule 2
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key noborder --type bool "true"
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key noborderrule 2
fi

# Directories
sudo rm -f /usr/share/dbus-1/system-services/org.freedesktop.UDisks2.service
mkdir -p "${HOME}/.config/autostart" "${HOME}/.XDG" "${HOME}/.local/share/"
chmod 700 "${HOME}/.XDG"
touch "${HOME}/.local/share/user-places.xbel"

# Setup application DB
if [ ! -f "/etc/xdg/menus/applications.menu" ]; then
  sudo mv \
    /etc/xdg/menus/plasma-applications.menu \
    /etc/xdg/menus/applications.menu
fi
kbuildsycoca6

# Export variables globally so all children inherit them
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_TYPE=wayland
export KDE_SESSION_VERSION=6
export DISPLAY=:1

sudo mkdir -p /tmp/.X11-unix
sudo chmod 1777 /tmp/.X11-unix

dbus-run-session bash -l -c '
    WAYLAND_DISPLAY=wayland-1 python3 /kwin-xwayland.py &
    KWIN_PID=$!
    sleep 2

    /usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1

    # The autostart scripts are not run by KDE, so we have to do it manually
    nohup bash /defaults/autostart.sh & disown

    WAYLAND_DISPLAY=wayland-0 plasmashell
    kill $KWIN_PID
' > /dev/null 2>&1

sleep 5
