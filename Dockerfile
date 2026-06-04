FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

ENV TITLE="XPipe Webtop"
ENV PIXELFLUX_WAYLAND=true

ARG XPIPE_PACKAGE
ARG XPIPE_REPOSITORY
ARG TARGETPLATFORM
ARG DEBIAN_FRONTEND="noninteractive"

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
    net-tools \
    dnsutils \
    iputils-ping \
    iproute2 \
    traceroute \
    nmap \
    netcat-traditional \
    tcpdump \
    socat \
    cargo \
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
    kwrite \
    libkf6dbusaddons-bin \
    wget \
    git \
    zip \
    unzip \
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
  cargo install \
    wl-clipboard-rs-tools && \
  echo "**** replace wl-clipboard with rust ****" && \
  mv \
    /config/.cargo/bin/wl-* \
    /usr/bin/ && \
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

# ports and volumes
EXPOSE 3000
EXPOSE 3001
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
    gnome-console \
    gnome-terminal \
    alacritty \
    kitty \
    tilix \
    kate \
    gedit \
    terminator \
    remmina \
    tmux \
    screen \
    remmina-plugin-rdp && \
 apt-get autoclean

RUN echo "**** kde tweaks ****" && \
    setcap -r \
    /usr/bin/kwin_wayland

RUN echo "**** use bash for sh ****" && \
    ln -s -f /usr/bin/bash /usr/bin/sh

# add local files
COPY /root /

RUN echo "**** Write env ****" && \
    echo "export WEBTOP_TARGETPLATFORM=$TARGETPLATFORM" >> /etc/profile.d/webtop-env.sh && \
    echo "export WEBTOP_XPIPE_PACKAGE=$XPIPE_PACKAGE" >> /etc/profile.d/webtop-env.sh && \
    echo "export WEBTOP_XPIPE_REPOSITORY=$XPIPE_REPOSITORY" >> /etc/profile.d/webtop-env.sh && \
    echo "export DEBIAN_FRONTEND=noninteractive" >> /etc/profile.d/webtop-env.sh

