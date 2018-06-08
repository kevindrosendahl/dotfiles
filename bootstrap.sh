#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

which git &>/dev/null git || echo "please install git" && exit 1

# clone dotfiles to ${HOME}/dotfiles
cd ${HOME}
git clone https://github.com/kevindrosendahl/dotfiles.git

# run ${HOME}/dotfiles/install.sh
cd dotfiles
${HOME}/dotfiles/install.sh
