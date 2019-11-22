#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ask_yes_no() {
  read -p "${1}? [Y/n]: " -r
  if [[ ${REPLY} =~ ^(yes|y| ) ]] || [[ -z ${REPLY} ]]; then
    echo 1
  else
    echo 0
  fi
}

install_brew() {
  if ! command -v brew >/dev/null; then
    echo && echo "installing Homebrew"
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    export PATH="/usr/local/bin:$PATH"
  fi
}

install_brew_packages() {
	echo && echo "* installing brew packages"
	cd ${DIR}

	set +e
	brew bundle

	if [[ "${?}" -ne 0 ]]; then
	    set -e
	    echo "for some reason brew seems to be having a hard time installing python. a retry usually works. retrying now"
	    brew bundle
	fi
	set -e
}

# much of this gleamed from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
set_options() {
  echo && echo "* setting macOS options (some may require a restart)"

  # Ask for the administrator password upfront
  sudo -v

  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "

  # Restart automatically if the computer freezes
  sudo systemsetup -setrestartfreeze on

  # Enable dark interface
  defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

  # Set key repeat preferences
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  defaults write NSGlobalDomain KeyRepeat -int 1

  # Disable automatic capitalization as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

  # Disable smart dashes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  # Disable automatic period substitution as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

  # Disable smart quotes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Trackpad: enable tap to click for this user and for the login screen
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # Save screenshots to the desktop
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"

  # Disable shadow in screenshots
  defaults write com.apple.screencapture disable-shadow -bool true

  # Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Display full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

  # Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Wipe all (default) app icons from the Dock
  defaults write com.apple.dock persistent-apps -array

  # Orient the Dock on the left
  defaults write com.apple.dock orientation -string "left"

  # Set the icon size of Dock items to 30 pixels
  defaults write com.apple.dock tilesize -int 30

  # Remove the auto-hiding Dock delay
  defaults write com.apple.dock autohide-delay -float 0

  # Remove the animation when hiding/showing the Dock
  defaults write com.apple.dock autohide-time-modifier -float 0

  # Autohide the Dock
  defaults write com.apple.dock autohide -int 1

  # Autohide the menu bar
  defaults write NSGlobalDomain _HIHideMenuBar -bool true

  # Hot corners
  # Possible values:
  #  0: no-op
  #  2: Mission Control
  #  3: Show application windows
  #  4: Desktop
  #  5: Start screen saver
  #  6: Disable screen saver
  #  7: Dashboard
  # 10: Put display to sleep
  # 11: Launchpad
  # 12: Notification Center
  # Disable thme all
  defaults write com.apple.dock wvous-tl-corner -int 0
  defaults write com.apple.dock wvous-tl-modifier -int 0
  defaults write com.apple.dock wvous-tr-corner -int 0
  defaults write com.apple.dock wvous-tr-modifier -int 0
  defaults write com.apple.dock wvous-bl-corner -int 0
  defaults write com.apple.dock wvous-bl-modifier -int 0
  defaults write com.apple.dock wvous-br-corner -int 0
  defaults write com.apple.dock wvous-br-modifier -int 0

  # Set up control strip defaults
  defaults write com.apple.controlstrip FullCustomized -array \
    'com.apple.system.group.brightness' \
    'com.apple.system.group.keyboard-brightness' \
    'com.apple.system.group.media' \
    'com.apple.system.group.volume' \
    'com.apple.system.screen-lock'

  defaults write com.apple.controlstrip MiniCustomized -array \
    'com.apple.system.brightness' \
    'com.apple.system.mute' \
    'com.apple.system.volume'

  # Show battery percentage in the menu bar
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"

  set +e
  for app in "Activity Monitor" \
        "Dock" \
        "Finder" \
        "SystemUIServer"; do
        killall "${app}" 2> /dev/null
  done
  set -e

  echo "Done. Note that some of these changes require a logout/restart to take effect."
}

DOTFILES=(
    .yabairc
)

DOTDIRS=(
    .hammerspoon
)

sync() {
	echo && echo "* syncing macOS dotfiles"
	for d in ${DOTFILES[@]}; do
		rsync ${DIR}/${d} ${HOME}/${d}
	done

	for d in ${DOTDIRS[@]}; do
		rsync -r ${DIR}/${d} ${HOME}
	done
}

set_shell() {
  echo && echo "* setting shell to zsh"
  local shell_path;
  shell_path="$(which zsh)"

  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  sudo chsh -s "$shell_path" "$USER"
}

start_hammerspoon() {
    [[ $(ask_yes_no "configure hammerspoon") -eq 0 ]] && return 0

    echo "starting hammerspoon"
    open /Applications/Hammerspoon.app
    cat << EOF
Please configure the following options for hammerspoon:
  - enable Launch Hammerspoon at login
  - enable Show menu item
  - disable Show dock icon
  - Enable Accessibility
EOF
    read -p "when complete, hit enter"
}

start_alfred() {
    echo
    [[ $(ask_yes_no "configure alfred") -eq 0 ]] && return 0

    echo "starting alfred"
    open "/Applications/Alfred 3.app"
    cat << EOF
Please configure the following options for hammerspoon:
  General:
    - enable Launch Alfred at login
    - set Alfred Hotkey to cmd + space
  Appearance:
    - Alfred macOS Dark
EOF
    read -p "when complete, hit enter"
}

start_yabai() {
    echo
    [[ $(ask_yes_no "configure yabai?") -eq 0 ]] && return 0

    echo "starting yabai"
    brew services run yabai
    echo "Please allow yabai accessibility permissions"
    read -p "when complete, hit enter"
    echo "restarting yabai"
    brew services restart yabai
}

start_services() {
    echo && echo "* configuring services"
    start_hammerspoon
    start_alfred
    start_yabai
}

if [[ $(which brew &>/dev/null) -ne 0 ]]; then
	echo "please install homebrew" && exit 1
fi

install_brew
install_brew_packages
set_options
sync
set_shell
start_services
