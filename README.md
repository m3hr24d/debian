# Debian
Dockerfile to build a debian:jessie baseimage with a couple of extra packages.

The image installs the following extra packages:

- `runit`
- `inetutils-ping`
- `iproute2`
- `net-tools`
- `dnsutils`
- `apt-utils`
- `apt-transport-https`
- `software-properties-common`
- `sudo`
- `locales`
- `ca-certificates`
- `mlocate`
- `vim-tiny`
- `wget`
- `unzip`

Additionally `apt` is configured to **NOT** install `recommended` and `suggested` packages.