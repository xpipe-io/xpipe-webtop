FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble AS build

ARG DEBIAN_FRONTEND="noninteractive"

ENV TITLE="XPipe Webtop"
ARG XPIPE_VERSION
ARG XPIPE_REPOSITORY
ARG XPIPE_PACKAGE
ARG TARGETPLATFORM

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

RUN echo "**** VsCode **** ($TARGETPLATFORM)" && \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then VSCODE_LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; else VSCODE_LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"; fi && \
  wget -O vscode.deb "${VSCODE_LINK}" && \
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

RUN echo "**** XPipe **** ($TARGETPLATFORM)" && \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then XPIPE_ARTIFACT="xpipe-installer-linux-x86_64.deb"; else XPIPE_ARTIFACT="xpipe-installer-linux-arm64.deb"; fi && \
  wget "https://github.com/$XPIPE_REPOSITORY/releases/download/$XPIPE_VERSION/${XPIPE_ARTIFACT}" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y "./${XPIPE_ARTIFACT}" && \
  rm "./${XPIPE_ARTIFACT}"

RUN mkdir -p "/config/.config/kdedefaults/autostart/" && ln -s "/usr/share/applications/$XPIPE_PACKAGE.desktop" "/config/.config/kdedefaults/autostart/$XPIPE_PACKAGE.desktop"

RUN echo "**** kde tweaks ****" && \
  sed -i \
    "s/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g;s#preferred://browser#preferred://browser,applications:$XPIPE_PACKAGE.desktop#g" \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
