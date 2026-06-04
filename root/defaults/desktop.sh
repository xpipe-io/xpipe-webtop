#!/bin/bash

kwriteconfig6 --file $HOME/.config/kwinrc --group Input --key TabletMode off

kwriteconfig6 --file $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc --group Containments \
  --group 2 --group Applets --group 15 --key plugin "org.kde.plasma.digitalclock"

KWIN_RULES_FILE="$HOME/.config/kwinrulesrc"
RULE_DESC="maximize mobile"
if grep -q "$RULE_DESC" "$KWIN_RULES_FILE" 2>/dev/null; then
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key Enabled false
fi

