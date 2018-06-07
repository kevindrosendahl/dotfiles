#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_brew() {
	echo "* installing brew packages"
	cd ${DIR}
	brew bundle
}

# much of this gleamed from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
set_options() {
  echo && echo "* setting macOS options"

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
    .chunkwmrc
)

DOTDIRS=(
    .hammerspoon
    .iterm2
)

sync() {
	echo && echo "* syncing macOS dotfiles"
	for d in ${DOTFILES[@]}; do
		rsync -v ${DIR}/${d} ${HOME}/${d}
	done

	for d in ${DOTDIRS[@]}; do
		rsync -rv ${DIR}/${d} ${HOME}
	done
}

start_hammerspoon() {
    echo "starting hammerspoon"
    open /Applications/Hammerspoon.app
    read -p "Please allow Hammerspoon accessibility permissions and enable it on startup, then hit enter"
}

start_alfred() {
    echo "starting alfred"
    open "/Applications/Alfred 3.app"
    read -p "Please set hotkey to cmd+space and enable on startup, then hit enter"
}

start_chunkwm() {
    echo "starting chunkwm"
    brew services run chunkwm
    read -p "Please allow chunkwm accessibility permissions, then hit enter to continue"
    echo "restarting chunkwm"
}

start_services() {
    start_hammerspoon
    start_alfred
    start_chunkwm
}

if [[ $(which brew &>/dev/null) -ne 0 ]]; then
	echo "please install homebrew" && exit 1
fi

install_brew
set_options
sync
start_services
