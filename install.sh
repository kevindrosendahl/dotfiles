#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLATFORMS_DIR=${DIR}/platform

DOTFILES=(
	.tmux.conf
	.vimrc
	.zshrc
)

DOTDIRS=(
	.vim
	.zsh
)

sync() {
	echo && echo "* syncing dotfiles"
	for d in ${DOTFILES[@]}; do
		ln -s ${DIR}/${d} ${HOME}/${d}
	done

	for d in ${DOTDIRS[@]}; do
		ln -s ${DIR}/${d} ${HOME}
	done
}

UNAME=$(uname)
case ${UNAME} in
	Darwin) 
		PLATFORM_DIR=${PLATFORMS_DIR}/macOS
		;;

	Linux)
		PLATFORM_DIR=${PLATFORMS_DIR}/linux
		;;

	*)
		echo "unsupported platform ${UNAME}" && exit 1	
    ;;
esac

# install
[ -f ${PLATFORM_DIR}/pre-install-hook.sh ] && ${PLATFORM_DIR}/pre-install-hook.sh
${PLATFORM_DIR}/install.sh
[ -f ${PLATFORM_DIR}/post-install-hook.sh ] && ${PLATFORM_DIR}/post-install-hook.sh

# sync dotfiles
[ -f ${PLATFORM_DIR}/pre-sync-hook.sh ] && ${PLATFORM_DIR}/pre-sync-hook.sh
sync
[ -f ${PLATFORM_DIR}/post-sync-hook.sh ] && ${PLATFORM_DIR}/post-sync-hook.sh

