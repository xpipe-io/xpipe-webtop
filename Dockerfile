FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

ENV TITLE="XPipe Webtop"
ENV PIXELFLUX_WAYLAND=true

ARG XPIPE_VERSION
ARG XPIPE_REPOSITORY
ARG XPIPE_PACKAGE
ARG TARGETPLATFORM
ARG DEBIAN_FRONTEND="noninteractive"

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
    cargo \
    dolphin \
    firefox \
    gwenview \
    kde-config-gtk-style \
    kdialog \
    kfind \
    khotkeys \
    ksystemstats \
    kio-extras \
    kubuntu-settings-desktop \
    kubuntu-wallpapers \
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
    plymouth-theme-kubuntu-logo \
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

RUN echo "**** XPipe **** ($TARGETPLATFORM)" && \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then XPIPE_ARTIFACT="xpipe-installer-linux-x86_64.deb"; else XPIPE_ARTIFACT="xpipe-installer-linux-arm64.deb"; fi && \
  wget "https://github.com/$XPIPE_REPOSITORY/releases/download/$XPIPE_VERSION/${XPIPE_ARTIFACT}" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y "./${XPIPE_ARTIFACT}" && \
  rm "./${XPIPE_ARTIFACT}"

RUN echo "**** kde tweaks ****" && \
    setcap -r \
    /usr/bin/kwin_wayland

RUN echo "**** sudo tweaks ****" && echo 'Defaults env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers

# add local files
COPY /root /

RUN echo "**** Create env file ****" && \
    echo "TARGETPLATFORM=$TARGETPLATFORM" >> /apps/env && \
    echo "XPIPE_VERSION=$XPIPE_VERSION" >> /apps/env

