# XPipe Webtop

XPipe Webtop is a web-based desktop environment that can be run as a docker/OCI container and accessed from a browser or the XPipe mobile app. The Ubuntu 26.04 + KDE6 based desktop environment comes with XPipe, various terminals, editors, and other useful tools preinstalled and configured. It also supports transferring your settings from your local installation to the webtop environment.

The webtop can either be set up manually or also through the built-in webtop deployment wizard in XPipe, which can automatically configure and deploy a webtop container for docker, podman, and Proxmox.

You can find the documentation at [https://docs.xpipe.io/guide/webtop](https://docs.xpipe.io/guide/webtop).

<div align="center">
    <img src="https://github.com/xpipe-io/.github/raw/main/img/webtop.png" width="77%" />
    <img src="https://github.com/xpipe-io/.github/raw/main/img/1x1.png" width="1%" />
    <img src="https://github.com/xpipe-io/.github/raw/main/img/webtop-mobile.png" width="20%"/>
</div>

## Development

If you want to make local modifications to these images for development purposes or just to customize the logic:

```bash
git clone https://github.com/xpipe-io/xpipe-webtop.git
cd xpipe-webtop
docker build .
```

### Running

You can run the container locally via docker compose by utilizing the files in `./compose`.

First, you can rename the file `.env.default` to `.env`. Then, you have to set the `XPIPE_DATA_DIR` location in the `.env` file to the mounted user data directory for the container. For the usage of `XPIPE_REPO_DIR` in the env file, see further down below. You can leave this value empty.

Then, you can run the container with the latest stable XPipe release:

```bash
docker compose --env-file ./compose/.env -f ./compose/core.yaml -f ./compose/prod-main.yaml up --build
```

To run the latest PTB release instead, you can use

```bash
docker compose --env-file ./compose/.env -f ./compose/core.yaml -f ./compose/prod-ptb.yaml up --build
```

### Dev builds

You can make use of a local development within the container by cloning the repository with `git clone https://github.com/xpipe-io/xpipe` and then passing a bind mount to `<path to repo dir>:/config/xpipe-dev`. You can do this by setting `XPIPE_REPO_DIR` in the `.env` file. This will then trigger a gradle build within the container.

You can run this with

```bash
docker compose --env-file ./compose/.env -f ./compose/core.yaml -f ./compose/dev.yaml up --build
```

### Debugging

You can also attach a Java debugger to the dev build of XPipe by passing the environment variable `XPIPE_DEBUG=1`. The started XPipe app will then wait and listen for a remote JDWP debugger to attach at port `7857`.

You can run this with

```bash
docker compose --env-file ./compose/.env -f ./compose/core.yaml -f ./compose/dev-debug.yaml up --build
```

### Tests

You can run the tests to check if all packages install correctly with

```bash
docker build -t xpipe-webtop-test . 
docker run --rm --entrypoint bash xpipe-webtop-test -l -c /apps/test.sh
```

To only test a single application install, you can pass the script file name with

```bash
docker run --rm --entrypoint bash xpipe-webtop-test -l -c "/apps/test.sh 1password"
```
