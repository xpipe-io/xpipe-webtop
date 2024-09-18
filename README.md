# XPipe Webtop

This docker image is a fork of https://github.com/linuxserver/docker-webtop that comes with XPipe and various terminals and editors preinstalled.

## Application Setup

The Webtop can be accessed at:

* https://yourhost:3001/

### Options in all KasmVNC based GUI containers

This container is based on [Docker Baseimage KasmVNC](https://github.com/linuxserver/docker-baseimage-kasmvnc) which means there are additional environment variables and run configurations to enable or disable specific functionality.

#### Optional environment variables

| Variable | Description |
| :----: | --- |
| CUSTOM_USER | HTTP Basic auth username, abc is default. |
| PASSWORD | HTTP Basic auth password, abc is default. If unset there will be no auth |
| SUBFOLDER | Subfolder for the application if running a subfolder reverse proxy, need both slashes IE `/subfolder/` |

## Usage

To help you get started creating a container from this image you can either use docker-compose or the docker cli.

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
      - 127.0.0.1:3001:3001
    restart: unless-stopped
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=xpipe-webtop \
  -e SUBFOLDER=/ `#optional` \
  -p 127.0.0.1:3001:3001 \
  -v /path/to/data:/config \
  -v /var/run/docker.sock:/var/run/docker.sock `#optional` \
  --restart unless-stopped \
  ghcr.io/xpipe-io/xpipe-webtop:latest
```

## Parameters

Containers are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 3001` | Web Desktop GUI HTTPS |
| `-e SUBFOLDER=/` | Specify a subfolder to use with reverse proxies, IE `/subfolder/` |
| `-v /config` | abc users home directory |
| `-v /var/run/docker.sock` | Docker Socket on the system, if you want to use Docker in the container |

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
