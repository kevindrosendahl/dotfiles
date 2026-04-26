#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APT_PACKAGES_FILE=${DIR}/apt-packages.txt

install_apt() {
    apt update
    sed 's/#.*//' "${APT_PACKAGES_FILE}" | xargs apt install -y
}

if [[ ! -r /etc/os-release ]]; then
    echo "/etc/os-release not found; cannot detect distro" >&2
    exit 1
fi

# shellcheck disable=SC1091
. /etc/os-release

case "${ID:-}" in
    debian | ubuntu)
        install_apt
        ;;
    *)
        echo "unsupported distro ${ID:-unknown}" && exit 1
        ;;
esac
