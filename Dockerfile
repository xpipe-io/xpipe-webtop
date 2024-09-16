FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

ARG DEBIAN_FRONTEND="noninteractive"

ENV TITLE="XPipe Webtop"
ARG XPIPE_VERSION="11.3"
ARG XPIPE_REPOSITORY="xpipe-io/xpipe"

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

RUN  echo "**** kde tweaks ****" && \
  sed -i \
    's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml

# add local files
COPY /root /

# ports and volumes
VOLUME /config

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://rawcdn.githack.com/xpipe-io/xpipe/a097ae7a41131fa358b5343345557ad00a45c309/dist/logo/logo.png

RUN echo "**** XPipe ****" && \
  wget "https://github.com/$XPIPE_REPOSITORY/releases/download/$XPIPE_VERSION/xpipe-installer-linux-x86_64.deb" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y "./xpipe-installer-linux-x86_64.deb" && \
  rm "./xpipe-installer-linux-x86_64.deb"

RUN mkdir -p "/config/.config/kdedefaults/autostart/" && ln -s "/usr/share/applications/xpipe.desktop" "/config/.config/kdedefaults/autostart/xpipe.desktop"
