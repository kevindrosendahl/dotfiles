#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

set_tmux_options() {
  echo 'set-option -g default-command "reattach-to-user-namespace -l zsh"' >> ${HOME}/.tmux.conf
}

set_tmux_options
