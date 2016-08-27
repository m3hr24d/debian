#!/usr/bin/env bash
set -eu

CURRENT_DIR=`dirname $(readlink -f $0)`
MKIMAGE_SCRIPT_URL='https://cdn.rawgit.com/docker/docker/master/contrib/mkimage.sh'
DEBOOTSTRAP_SCRIPT_URL='https://cdn.rawgit.com/docker/docker/master/contrib/mkimage/debootstrap'

INCLUDE=${INCLUDE:-runit,inetutils-ping,iproute2,vim-tiny,wget,sudo,net-tools,ca-certificates,apt-utils,software-properties-common,apt-transport-https,locales,unzip,dnsutils,mlocate}
VARIANT=${VARIANT:-minbase}
COMPONENTS=${COMPONENTS:-main}
SUITE=${SUITE:-jessie}
MIRROR=${MIRROR:-http://httpredir.debian.org/debian}

download() {
    local CURL_COMMAND=`command -v curl`
    local WGET_COMMAND=`command -v wget`
    local DOWNLOAD_PATH=${2:-$CURRENT_DIR}

    if [[ -n "$CURL_COMMAND" ]]; then
        (cd ${DOWNLOAD_PATH} && ${CURL_COMMAND} -SLO $1)
        return
    elif [[ -n "$WGET_COMMAND" ]]; then
        ${WGET_COMMAND} -P ${DOWNLOAD_PATH} $1
        return
    else
        echo 'You must install at least "curl" or "wget".'
        exit 1
    fi
}

mkdir -p ${CURRENT_DIR}/mkimage
test -x ${CURRENT_DIR}/mkimage.sh || (download ${MKIMAGE_SCRIPT_URL} ${CURRENT_DIR} && chmod +x ${CURRENT_DIR}/mkimage.sh)
test -x ${CURRENT_DIR}/mkimage/debootstrap || (download ${DEBOOTSTRAP_SCRIPT_URL} ${CURRENT_DIR}/mkimage && chmod +x ${CURRENT_DIR}/mkimage/debootstrap)

cat >> "$CURRENT_DIR/mkimage/debootstrap" <<-'HEREDOC'
# apt is configured to NOT install recommended and suggested packages.
cat > "$rootfsDir/etc/apt/apt.conf.d/01norecommends" <<-EOF
APT::Install-Recommends 0;
APT::Install-Suggests 0;
EOF
HEREDOC

${CURRENT_DIR}/mkimage.sh -d ${CURRENT_DIR} debootstrap --arch=amd64 --force-check-gpg --keyring=${CURRENT_DIR}/debian-archive-keyring.gpg --variant=${VARIANT} --components=${COMPONENTS} --include=${INCLUDE} ${SUITE} ${MIRROR}
