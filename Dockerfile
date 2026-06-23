# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv
FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

# From https://github.com/linuxserver/docker-baseimage-selkies?tab=readme-ov-file#options
ENV TITLE="XPipe Webtop"
ENV PIXELFLUX_WAYLAND=true
ENV AUTO_GPU=true
ENV FILE_MANAGER_PATH=/config
ENV NO_GAMEPAD=true

# From https://github.com/linuxserver/docker-baseimage-selkies?tab=readme-ov-file#selkies-application-settings
ENV SELKIES_UI_TITLE="XPipe"
ENV SELKIES_UI_SHOW_LOGO=false
ENV SELKIES_UI_SIDEBAR_SHOW_AUDIO_SETTINGS=false
ENV SELKIES_UI_SIDEBAR_SHOW_APPS=false
ENV SELKIES_UI_SIDEBAR_SHOW_SHARING=false
ENV SELKIES_UI_SIDEBAR_SHOW_GAMEPADS=false
ENV SELKIES_UI_SIDEBAR_SHOW_GAMING_MODE=false
ENV SELKIES_MICROPHONE_ENABLED=false
ENV SELKIES_GAMEPAD_ENABLED=false
ENV SELKIES_COMMAND_ENABLED=false
ENV SELKIES_ENABLE_SHARING=false
ENV SELKIES_ENABLE_COLLAB=false
ENV SELKIES_ENABLE_SHARED=false
ENV SELKIES_ENABLE_PLAYER2=false
ENV SELKIES_ENABLE_PLAYER3=false
ENV SELKIES_ENABLE_PLAYER4=false
ENV SELKIES_FRAMERATE=30
ENV SELKIES_UI_SIDEBAR_SHOW_VIDEO_SETTINGS=false
ENV SELKIES_UI_SHOW_CORE_BUTTONS=false
ENV SELKIES_AUDIO_ENABLED=false

ENV XPIPE_API_KEY=""
ENV XPIPE_WIZARD_PRECONFIGURED=false
ENV XPIPE_PREINSTALLED_WEBTOP_APPS=""

ARG XPIPE_PACKAGE="xpipe"
ARG TARGETPLATFORM
ARG DEBIAN_FRONTEND="noninteractive"

# Displays
EXPOSE 3000
EXPOSE 3001

# JDWP debugger
EXPOSE 7857

# API port
EXPOSE 21721

# SSH server
EXPOSE 21722

# prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

RUN  echo "**** install base packages ****" && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    man-db \
    manpages  \
    dialog \
    bash-completion \
    kscreen \
    at-spi2-core \
    net-tools \
    dnsutils \
    iputils-ping \
    iproute2 \
    traceroute \
    nmap \
    netcat-traditional \
    ethtool \
    xz-utils \
    mtr \
    tcpdump \
    socat \
    dolphin \
    firefox \
    xdg-desktop-portal \
    gwenview \
    kde-config-gtk-style \
    htop \
    kdialog \
    kfind \
    khotkeys \
    ksystemstats \
    kio-extras \
    kwin-addons \
    kwin-x11 \
    fastfetch \
    kwrite \
    libkf6dbusaddons-bin \
    wget \
    git \
    libfuse2 \
    zip \
    unzip \
    debian-goodies \
    kmod \
    nano \
    mousepad \
    vim \
    neovim \
    plasma-desktop \
    plasma-workspace \
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

RUN  echo "**** Enable manpages ****" && \
     rm /etc/dpkg/dpkg.cfg.d/excludes && \
     apt-get update && \
     apt-get --reinstall install man-db manpages -y && \
     apt-get install manpages-posix manpages-posix-dev -y && \
     mv /usr/bin/man.REAL /usr/bin/man && \
     mandb -c

RUN echo "**** nerdfonts ****" && \
  curl -LO "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip" && \
  mkdir -p "/usr/share/fonts/ubuntu-mono-nerd" && \
  unzip "UbuntuMono.zip" -d "/usr/share/fonts/ubuntu-mono-nerd" && \
  rm "UbuntuMono.zip" && \
  fc-cache -fv

VOLUME /config

RUN \
  echo "**** add icon ****" && \
  curl -L -o \
    /usr/share/selkies/www/icon.png \
    "https://rawcdn.githack.com/xpipe-io/xpipe/a097ae7a41131fa358b5343345557ad00a45c309/dist/logo/logo.png"

RUN  echo "**** install tool packages ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    konsole \
    alacritty \
    kate \
    remmina \
    screen \
    remmina-plugin-rdp && \
 apt-get autoclean

RUN echo "**** kde tweaks ****" && \
    setcap -r /usr/bin/kwin_wayland

RUN echo "**** use bash for sh ****" && \
    ln -s -f /usr/bin/bash /usr/bin/sh

# add local files
COPY /root /

RUN echo "**** Fix wl-clipboard ****" && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then PLATFORM="amd64"; else PLATFORM="arm64"; fi && \
    apt-get install --no-install-recommends -y "/defaults/wl-clipboard_2.3.0-1_$PLATFORM.deb"

RUN echo "**** Write env ****" && \
    echo "export WEBTOP_TARGETPLATFORM=$TARGETPLATFORM" >> /etc/profile.d/webtop-env.sh && \
    echo "export WEBTOP_XPIPE_PACKAGE=$XPIPE_PACKAGE" >> /etc/profile.d/webtop-env.sh && \
    echo "export DEBIAN_FRONTEND=noninteractive" >> /etc/profile.d/webtop-env.sh

