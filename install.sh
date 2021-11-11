#!/usr/bin/env bash

set -eu
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sync_dotfiles() {
  local dotfiles_dir="${1}"

	# shellcheck disable=SC2207
	local entries=($(ls -A "${dotfiles_dir}"))

	for entry in "${entries[@]}"
	do
	  local full_path="${dotfiles_dir}/${entry}"
	  if [[ -f "${full_path}" ]]; then
      ln -sfF "${full_path}" "${HOME}/${entry}"
    elif [[ -d "${full_path}" ]]; then
      ln -sfF "${full_path}" "${HOME}"
    fi
	done
}

install_tmux_plugins() {
  TPM_PATH="${HOME}/.tmux/plugins/tpm"
  if [[ ! -d "${TPM_PATH}" ]]; then
    mkdir -p "$(dirname "${TPM_PATH}")"
    git clone https://github.com/tmux-plugins/tpm "${TPM_PATH}"
  fi

  "${TPM_PATH}"/bin/install_plugins
}

UNAME=$(uname)
case ${UNAME} in
    Darwin)
        PLATFORM="macOS"
        ;;

    Linux)
        PLATFORM="linux"
        ;;

    *)
        echo "unsupported platform ${UNAME}" && exit 1
        ;;
esac

sync_dotfiles "${DIR}/dotfiles"
sync_dotfiles "${DIR}/${PLATFORM}/dotfiles"
"${DIR}"/"${PLATFORM}"/install.sh
install_tmux_plugins
