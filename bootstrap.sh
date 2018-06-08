#!/bin/sh
set -u

need_cmd() {
    if ! command -v "$1" > /dev/null 2>&1
    then "please install $1"
    fi
}

need_cmd git
need_cmd curl

# clone dotfiles to ${HOME}/dotfiles
cd ${HOME}
git clone https://github.com/kevindrosendahl/dotfiles.git

# run ${HOME}/dotfiles/install.sh
cd dotfiles
${HOME}/dotfiles/install.sh
