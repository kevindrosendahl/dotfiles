set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APT_PACKAGES_FILE=${DIR}/apt-packages.txt

install_apt() {
	apt update
	sed 's/#.*//' ${APT_PACKAGES_FILE} | xargs apt install -y
}

DISTRO=$(cat /etc/os-release | grep ID= | grep -v VERSION | cut -d '=' -f2)
case ${DISTRO} in
  debian | ubuntu) 
    install_apt
    ;;
  *)
    echo "unsupported distro ${DISTRO}" && exit 1
    ;;
esac

