FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble AS build

ARG DEBIAN_FRONTEND="noninteractive"

ENV TITLE="XPipe Webtop"
# not shure if the DISABLE_SANDBOX is helping
ENV DISABLE_SANDBOX=1
ARG XPIPE_VERSION
ARG XPIPE_REPOSITORY
ARG XPIPE_PACKAGE
ARG TARGETPLATFORM

RUN echo "**** check build args ****" \
  && test -n "$XPIPE_VERSION" || (echo "\033[31mERROR [build] RUN: There was an error: the build argument XPIPE_VERSION must be set!\033[0m" && exit 1) \
  && test -n "$XPIPE_REPOSITORY" || (echo "\033[31mERROR [build] RUN: There was an error: the build argument XPIPE_REPOSITORY must be set! (recommended is xpipe-io/xpipe)\033[0m" && exit 1) \
  && test -n "$XPIPE_PACKAGE" || (echo "\033[31mERROR [build] RUN: There was an error: the build argument XPIPE_PACKAGE must be set! (recommended is xpipe)\033[0m" && exit 1)


# prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

RUN  echo "**** install base packages ****" && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    dolphin \
    firefox \
    gwenview \
    kde-config-gtk-style \
    kdialog \
    kio-extras \
    kubuntu-settings-desktop \
    kwin-x11 \
    kwrite \
    wget \
    git \
    zip \
    unzip \
    kmod \
    nano \
    mousepad \
    vim \
    plasma-desktop \
    plasma-workspace \
    plymouth-theme-kubuntu-logo \
    qml-module-qt-labs-platform \
    fonts-noto \
    fonts-noto-cjk \
    systemsettings && \
 apt-get remove -y plasma-welcome && \
 apt-get autoclean && \
 rm -rf \
   /config/.cache \
   /config/.launchpadlib \
   /var/lib/apt/lists/* \
   /var/tmp/* \
   /tmp/*

RUN echo "**** nerdfonts ****" && \
  curl -LO "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip" && \
  mkdir -p "/usr/share/fonts/ubuntu-mono-nerd" && \
  unzip "UbuntuMono.zip" -d "/usr/share/fonts/ubuntu-mono-nerd" && \
  rm "UbuntuMono.zip" && \
  fc-cache -fv

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
EXPOSE 3001
VOLUME /config

RUN \
  echo "**** add icon ****" && \
  curl -L -o \
    /kclient/public/icon.png \
    "https://rawcdn.githack.com/xpipe-io/xpipe/a097ae7a41131fa358b5343345557ad00a45c309/dist/logo/logo.png"

RUN  echo "**** install tool packages ****" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    konsole \
    gnome-console \
    gnome-terminal \
    xfce4-terminal \
    alacritty \
    kitty \
    tilix \
    kate \
    gedit \
    terminator \
    freerdp2-x11 \
    remmina \
    tmux \
    screen \
    remmina-plugin-rdp && \
 apt-get autoclean

RUN echo "**** tailscale ****" && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list && \
    sudo apt-get update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y tailscale

RUN echo "**** netbird ****" && \
    sudo apt-get update && \
    sudo apt-get install ca-certificates curl gnupg -y && \
    curl -sSL https://pkgs.netbird.io/debian/public.key | sudo gpg --dearmor --output /usr/share/keyrings/netbird-archive-keyring.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/netbird-archive-keyring.gpg] https://pkgs.netbird.io/debian stable main' | sudo tee /etc/apt/sources.list.d/netbird.list && \
    sudo apt-get update && \
    sudo apt-get install netbird

RUN echo "**** teleport ****" && sudo curl https://apt.releases.teleport.dev/gpg -o /etc/apt/keyrings/teleport-archive-keyring.asc && \
    . /etc/os-release && \
    echo "deb [signed-by=/etc/apt/keyrings/teleport-archive-keyring.asc] https://apt.releases.teleport.dev/${ID?} ${VERSION_CODENAME?} stable/v17" | sudo tee /etc/apt/sources.list.d/teleport.list > /dev/null && \
    sudo apt-get update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get -y install teleport

RUN echo "**** kubectl **** ($TARGETPLATFORM)" && \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then KUBECTL_LINK="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; else KUBECTL_LINK="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"; fi && \
  curl -LO "${KUBECTL_LINK}" && \
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
  rm kubectl

RUN echo "**** aws ****" && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
  unzip "/tmp/awscliv2.zip" -d "/tmp" && \
  sudo "/tmp/aws/install" && \
  rm -rf "/tmp/aws" "/tmp/awscliv2.zip"

RUN echo "**** aws ssm **** ($TARGETPLATFORM)" && \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then SSM_LINK="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"; else SSM_LINK="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb"; fi && \
  curl "${SSM_LINK}" -o "/tmp/session-manager-plugin.deb" && \
  sudo dpkg -i "/tmp/session-manager-plugin.deb" && \
  rm -rf "/tmp/aws" "/tmp/session-manager-plugin.deb"

RUN echo "**** zellij **** ($TARGETPLATFORM)" && \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ZELLIJ_LINK="https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"; else ZELLIJ_LINK="https://github.com/zellij-org/zellij/releases/latest/download/zellij-aarch64-unknown-linux-musl.tar.gz"; fi && \
  curl -LO "${ZELLIJ_LINK}" && \
  tar -xvf zellij*.tar.gz && \
  sudo install -o root -g root -m 0755 zellij /usr/local/bin/zellij && \
  rm zellij && \
  rm zellij*.tar.gz

RUN echo "**** dolphin tweaks ****" && printf "x-scheme-handler/file=org.kde.dolphin.desktop\n" >> /usr/share/applications/kde-mimeapps.list

RUN echo "**** XPipe **** ($TARGETPLATFORM)" && \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then XPIPE_ARTIFACT="xpipe-installer-linux-x86_64.deb"; else XPIPE_ARTIFACT="xpipe-installer-linux-arm64.deb"; fi && \
  wget "https://github.com/$XPIPE_REPOSITORY/releases/download/$XPIPE_VERSION/${XPIPE_ARTIFACT}" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y "./${XPIPE_ARTIFACT}" && \
  rm "./${XPIPE_ARTIFACT}"

RUN mkdir -p "/etc/xdg/autostart/" && ln -s "/usr/share/applications/$XPIPE_PACKAGE.desktop" "/etc/xdg/autostart/$XPIPE_PACKAGE.desktop"

RUN echo "**** VsCode **** ($TARGETPLATFORM)" && \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then VSCODE_LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; else VSCODE_LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"; fi && \
  wget -O vscode.deb "${VSCODE_LINK}" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y "./vscode.deb" && \
  rm "./vscode.deb"

# fix vscode
RUN mv /usr/share/code/code /usr/share/code/code-sandbox

RUN echo '#!/bin/bash\n/usr/share/code/code-sandbox --no-sandbox "$@"' > /usr/share/code/code && \
    chmod +x /usr/share/code/code && \
    sudo ln -sf /usr/share/code/code /usr/bin/code

RUN echo "**** kde tweaks ****" && \
    sed -i \
    "s/applications:org.kde.discover.desktop,/,/g" \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
    sed -i \
    "s#preferred://browser#applications:firefox.desktop,applications:org.kde.konsole.desktop,applications:code.desktop,applications:org.remmina.Remmina.desktop,applications:$XPIPE_PACKAGE.desktop#g" \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
