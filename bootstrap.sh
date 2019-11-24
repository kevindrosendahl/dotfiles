#!/bin/sh
set -u

need_cmd() {
    if ! command -v "$1" > /dev/null 2>&1
        then "please install $1"
    fi
}

need_cmd git
need_cmd curl

set -e

# Clone dotfiles to ${HOME}/src/github.com/kevindrosendahl/dotfiles
GIT_DIR="${HOME}/src/github.com/kevindrosendahl"
mkdir -p ${GIT_DIR}
cd ${GIT_DIR}
git clone https://github.com/kevindrosendahl/dotfiles.git

# Run install script.
${HOME}/src/github.com/kevindrosendahl/dotfiles/install.sh
