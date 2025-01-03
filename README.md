![Webtop](https://github.com/xpipe-io/.github/raw/main/img/webtop.png)

# XPipe Webtop

XPipe Webtop is a web-based desktop environment that can be run in a container and accessed from a browser via KasmVNC.
The desktop environment comes with XPipe and various terminals and editors preinstalled and configured.
This docker image is a fork of https://github.com/linuxserver/docker-webtop.

## Application Setup

The Webtop can be accessed at:

* http://localhost:3000/
* https://localhost:3001/

## Authentication

Note that the authentication setup has to be done by you. By default, there is no authentication enabled and the webtop will be available to everyone.
So you have to be careful not to publicly expose it in that state.
As seen below, there are options to use basic HTTP authentication to restrict access.
However, this might also not be considered very secure, and it is recommended to use a proper separate authentication solution in front of the actual webtop environment.
Examples are Authelia, Authentik, KeyCloak, and others.

### Options in all KasmVNC based GUI containers

This container is based on [Docker Baseimage KasmVNC](https://github.com/linuxserver/docker-baseimage-kasmvnc) which means there are additional environment variables and run configurations to enable or disable specific functionality.

| Variable | Description |
| :----: | --- |
| CUSTOM_USER | HTTP Basic auth username, abc is default. |
| PASSWORD | HTTP Basic auth password, abc is default. If unset there will be no auth |
| SUBFOLDER | Subfolder for the application if running a subfolder reverse proxy, need both slashes IE `/subfolder/` |

## Usage

To help you get started creating a container from this image you can either use docker-compose or the docker cli.

The webtop image is available for both `linux/amd64` and `linux/arm64` platforms.

### docker-compose (recommended, [click here for more info](https://docs.linuxserver.io/general/docker-compose))

```yaml
---
services:
  webtop:
    image: ghcr.io/xpipe-io/xpipe-webtop:latest
    container_name: xpipe-webtop
    environment:
      - SUBFOLDER=/ #optional
    volumes:
      - /path/to/data:/config
      - /var/run/docker.sock:/var/run/docker.sock #optional
    ports:
      - 127.0.0.1:3000:3000
      - 127.0.0.1:3001:3001
    restart: unless-stopped
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=xpipe-webtop \
  -e SUBFOLDER=/ `#optional` \
  -p 127.0.0.1:3000:3000 \
  -p 127.0.0.1:3001:3001 \
  -v /path/to/data:/config \
  -v /var/run/docker.sock:/var/run/docker.sock `#optional` \
  --restart unless-stopped \
  ghcr.io/xpipe-io/xpipe-webtop:latest
```

## Public Test Builds

There are also image variants published for the [XPipe PTB](https://github.com/xpipe-io/xpipe-ptb) in case you're interested in trying out early test versions. You can obtain these images by replacing the `:latest` tag with the `:ptb` tag.

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```bash
git clone https://github.com/xpipe-io/xpipe-webtop.git
cd xpipe-webtop
docker build \
  --no-cache \
  --pull \
  .
```
