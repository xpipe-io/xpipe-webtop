#!/bin/bash

if [ -d $HOME/xpipe-dev ]; then
   curl -s "https://get.sdkman.io" | bash
   source "$HOME/.sdkman/bin/sdkman-init.sh"
   sdk install java 26.0.1-zulu
   source "$HOME/.sdkman/bin/sdkman-init.sh"
   cd $HOME/xpipe-dev
   $HOME/xpipe-dev/gradlew :dist:clean distAndInstall
  # sudo apt install $HOME/xpipe-dev/dist/build/dist/artifacts/xpipe-installer-linux-x86_64.deb
else
  if [ "$WEBTOP_TARGETPLATFORM" = "linux/amd64" ];
    then XPIPE_ARTIFACT="xpipe-installer-linux-x86_64.deb"
  else
    XPIPE_ARTIFACT="xpipe-installer-linux-arm64.deb"
  fi
  wget "https://github.com/$WEBTOP_XPIPE_REPOSITORY/releases/latest/download/${XPIPE_ARTIFACT}"
  apt-get update
  apt-get install --no-install-recommends -y "./${XPIPE_ARTIFACT}"
  rm "./${XPIPE_ARTIFACT}"
fi