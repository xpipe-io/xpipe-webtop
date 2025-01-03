ARG BASE_IMAGE_TAG
FROM scratch AS base

FROM base AS build-arm64
ARG BASE_IMAGE_TAG=arm64v8-ubuntunoble

FROM base AS build-amd64
ARG BASE_IMAGE_TAG=ubuntunoble

FROM ghcr.io/linuxserver/baseimage-kasmvnc:${BASE_IMAGE_TAG}

ARG DEBIAN_FRONTEND="noninteractive"

ENV TITLE="XPipe Webtop"
ARG XPIPE_VERSION
ARG XPIPE_REPOSITORY
ARG XPIPE_PACKAGE

# prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

RUN  echo "**** install packages ****" && \
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
    konsole \
    kubuntu-settings-desktop \
    kwin-x11 \
    kwrite \
    wget \
    git \
    plasma-desktop \
    plasma-workspace \
    plymouth-theme-kubuntu-logo \
    qml-module-qt-labs-platform \
    alacritty \
    kitty \
    tilix \
    kate \
    gedit \
    terminator \
    systemsettings && \
 apt-get remove -y plasma-welcome && \
 apt-get autoclean && \
 rm -rf \
   /config/.cache \
   /config/.launchpadlib \
   /var/lib/apt/lists/* \
   /var/tmp/* \
   /tmp/*

RUN echo "**** VsCode ****" && \
  wget -O vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y "./vscode.deb" && \
  rm "./vscode.deb"

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config

RUN \
  echo "**** add icon ****" && \
  curl -L -o \
    /kclient/public/icon.png \
    https://rawcdn.githack.com/xpipe-io/xpipe/a097ae7a41131fa358b5343345557ad00a45c309/dist/logo/logo.png

RUN echo "**** XPipe ****" && \
  wget "https://github.com/$XPIPE_REPOSITORY/releases/download/$XPIPE_VERSION/xpipe-installer-linux-x86_64.deb" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y "./xpipe-installer-linux-x86_64.deb" && \
  rm "./xpipe-installer-linux-x86_64.deb"

RUN mkdir -p "/config/.config/kdedefaults/autostart/" && ln -s "/usr/share/applications/$XPIPE_PACKAGE.desktop" "/config/.config/kdedefaults/autostart/$XPIPE_PACKAGE.desktop"

RUN echo "**** kde tweaks ****" && \
  sed -i \
    "s/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g;s#preferred://browser#preferred://browser,applications:$XPIPE_PACKAGE.desktop#g" \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
