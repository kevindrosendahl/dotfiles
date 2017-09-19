common=(
  .tmux.conf
  .vimrc
)

install_target() {
  target="${HOME}/${1}"

  if [ -h ${target} ]; then
    rm ${target}
  elif [ -d ${target} ]; then
    rm -rf ${target}
  fi

  ln -s "${PWD}/${1}" "${target}"
  echo "Installed ${1}"
}

for c in ${common}; do
  install_target ${c}
done

WORK=0
while getopts 'w' flag; do
  case "${flag}" in
    w) WORK=1 ;;
    *) echo "Unexpected option ${flag}" && exit 1;;
  esac
done

function install_darwin() {
  mac=(
    .iterm2
  )

  for m in ${mac}; do
    install_target ${m}
  done

  if [[ $(which brew &>/dev/null) -ne 0 ]]; then
    echo "Must install homebrew" && exit 1
  fi
  brew bundle

  if [[ ${WORK} -gt 0 ]]; then
    cd work
    brew bundle
  fi
}

UNAME=$(uname)
case ${UNAME} in
  Darwin) 
    install_darwin
    ;;
  *)
    echo "Unsupported platform ${UNAME}"
    ;;
esac

