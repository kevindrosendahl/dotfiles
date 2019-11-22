#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

set_tmux_options() {
  cat > "${HOME}/.tmux.conf" <<- EOF
# clobbered together from:
# - https://superuser.com/questions/747299/how-do-i-increase-the-copy-buffer-size-in-tmux
# - https://github.com/ngs/dotfiles/blob/master/rc.d/tmux.conf
unbind -Tcopy-mode-vi Enter
bind-key -Tcopy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
bind-key -Tcopy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

set-option -g default-command "reattach-to-user-namespace -l zsh
EOF
}

set_tmux_options
