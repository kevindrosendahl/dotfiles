set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_brew() {
	echo "installing brew packages"
	cd ${DIR}
	brew bundle
}

if [[ $(which brew &>/dev/null) -ne 0 ]]; then
	echo "please install homebrew" && exit 1
fi

install_brew

