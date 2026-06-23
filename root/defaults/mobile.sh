#!/bin/bash

kwriteconfig6 --file $HOME/.config/kwinrc --group Input --key TabletMode on

kwriteconfig6 --file $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc --group Containments \
  --group 2 --group Applets --group 15 --key plugin "org.kde.plasma.marginsseperator"

KWIN_RULES_FILE="$HOME/.config/kwinrulesrc"
RULE_DESC="maximize mobile"
RULE_ID=231923
if ! grep -q "$RULE_DESC" "$KWIN_RULES_FILE" 2>/dev/null; then
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
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key maximizehoriz --type bool "true"
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key maximizevert --type bool "true"
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key maximizehorizrule 3
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key maximizevertrule 3
else
  kwriteconfig6 --file "$KWIN_RULES_FILE" --group "$RULE_ID" --key Enabled true
fi

