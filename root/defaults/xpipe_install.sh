#!/bin/bash

if [ -d $HOME/xpipe-dev ]; then
   curl -s "https://get.sdkman.io" | bash
   source "$HOME/.sdkman/bin/sdkman-init.sh"
   sdk install java 26.0.1-zulu
   source "$HOME/.sdkman/bin/sdkman-init.sh"
   cd $HOME/xpipe-dev
   $HOME/xpipe-dev/gradlew clean distAndInstall
  # sudo apt install $HOME/xpipe-dev/dist/build/dist/artifacts/xpipe-installer-linux-x86_64.deb
else
  wget -qO- https://xpipe.io/signatures/0xDD3E0AD0.gpg > xpipe.gpg
  sudo install -D -o root -g root -m 644 xpipe.gpg /etc/apt/keyrings/xpipe.gpg
  rm xpipe.gpg
  sudo sh -c 'echo "deb [signed-by=/etc/apt/keyrings/xpipe.gpg] https://apt.xpipe.io/ stable main" > /etc/apt/sources.list.d/xpipe.list'
  sudo apt update && sudo apt install xpipe
fi