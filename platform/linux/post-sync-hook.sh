#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

echo 'set -g default-shell /bin/zsh' >> ${HOME}/.tmux.conf
