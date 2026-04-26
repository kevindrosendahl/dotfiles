#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "installing macos"

ask_yes_no() {
    read -p "${1}? [Y/n]: " -r
    if [[ ${REPLY} =~ ^(yes|y| ) ]] || [[ -z ${REPLY} ]]; then
        echo 1
    else
        echo 0
    fi
}

install_brew_packages() {
    echo && echo "* installing brew packages"
    cd "${DIR}"
    brew bundle
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

    # Disable press-and-hold accent picker so held keys repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Don't minimize windows when double-clicking the title bar
    defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

    # Tab through all controls in dialogs, not just text fields
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Disable window open/close animations
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

    # Near-instant window resize
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

    # Expand save panels by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Save to disk by default, not iCloud
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

    # Show all file extensions in Finder
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Trackpad: enable tap to click for built-in trackpad, Magic Trackpad,
    # current user, and login screen
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Mouse tracking speed
    defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.5

    # Enable Force Click on trackpad
    defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true

    # Reduce motion (accessibility)
    defaults write com.apple.universalaccess reduceMotion -bool true

    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    # Save screenshots to the ~/.screenshots
    mkdir -p "${HOME}/.screenshots"
    defaults write com.apple.screencapture location -string "${HOME}/.screenshots"

    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    defaults write com.apple.screencapture type -string "png"

    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true

    # Finder: show hidden files by default
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Default to list view
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Search current folder by default (not whole Mac)
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Desktop disk visibility: hide internal, show external + removable
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    # Don't warn when changing a file's extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Sort folders first when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # Show path bar and status bar in Finder windows
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Wipe all (default) app icons from the Dock
    defaults write com.apple.dock persistent-apps -array

    # Orient the Dock on the left
    defaults write com.apple.dock orientation -string "left"

    # Set the icon size of Dock items to 45 pixels
    defaults write com.apple.dock tilesize -int 45

    # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-delay -float 0

    # Remove the animation when hiding/showing the Dock
    defaults write com.apple.dock autohide-time-modifier -float 0

    # Autohide the Dock
    defaults write com.apple.dock autohide -int 1

    # Don't auto-rearrange Spaces based on most recent use
    defaults write com.apple.dock mru-spaces -bool false

    # Hide "Recent applications" section in Dock
    defaults write com.apple.dock show-recents -bool false

    # Disable Dock launch-bounce animation
    defaults write com.apple.dock launchanim -bool false

    # Minimize windows into their app icon, not a separate Dock slot
    defaults write com.apple.dock minimize-to-application -bool true

    # Autohide the menu bar always (System Settings -> Control Center ->
    # "Automatically hide and show the menu bar" -> "Always"). Both keys
    # are required on macOS 13+; setting only _HIHideMenuBar is ignored
    # because AppleMenuBarVisibleInFullscreen wins. Takes effect after
    # logout/reboot — killall doesn't reliably pick it up on Sequoia+.
    defaults write NSGlobalDomain _HIHideMenuBar -bool true
    defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -bool false

    # Speed up Mission Control animations
    defaults write com.apple.dock expose-animation-duration -float 0.1

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

    # Show battery percentage in the menu bar (Control Center on macOS 11+)
    defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

    # Menu bar clock: day-of-week + AM/PM, no date
    defaults write com.apple.menuextra.clock ShowDate -int 0
    defaults write com.apple.menuextra.clock ShowDayOfWeek -int 1
    defaults write com.apple.menuextra.clock ShowAMPM -int 1

    # Stop Time Machine from prompting on every new disk
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

    set +e
    for app in "Activity Monitor" \
          "ControlCenter" \
          "Dock" \
          "Finder" \
          "SystemUIServer"; do
          killall "${app}" 2> /dev/null
    done
    set -e

    echo "Done. Note that some of these changes require a logout/restart to take effect."
}

set_shell() {
  echo && echo "* setting shell to zsh"
  local shell_path;
  shell_path="$(which zsh)"

  if ! grep -qxF "$shell_path" /etc/shells ; then
    sudo sh -c "echo \"$shell_path\" >> /etc/shells"
  fi
  sudo chsh -s "$shell_path" "$USER"
}

configure_hammerspoon() {
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
    read -r -p "when complete, hit enter"
}

configure_alfred() {
    echo
    [[ $(ask_yes_no "configure alfred") -eq 0 ]] && return 0

    echo "starting alfred"
    open "/Applications/Alfred 5.app"
    cat << EOF
Please configure the following options for hammerspoon:
  General:
    - enable Launch Alfred at login
    - set Alfred Hotkey to cmd + space
  Appearance:
    - Alfred macOS Dark
EOF
    read -r -p "when complete, hit enter"
}

create_ssh_key() {
    [[ $(ask_yes_no "create ssh key") -eq 0 ]] && return 0

    DATESTAMP=$(date '+%m%d%y')
    KEY_PATH=~/.ssh/id_ed25519-github-${DATESTAMP}
    ssh-keygen -o -a 100 -t ed25519 -f "${KEY_PATH}" -C kevindrosendahl@gmail.com

    PUBLIC_KEY=$(cat "${KEY_PATH}.pub")
    cat << EOF
Please add the following public key to your Github profile:
${PUBLIC_KEY}
EOF
    read -r -p "when complete, hit enter"
}

configure_commit_signing() {
    [[ $(ask_yes_no "configure git signing") -eq 0 ]] && return 0

    echo "pinentry-program $(command -v pinentry-mac)" >> ~/.gnupg/gpg-agent.conf

    gpg --full-generate-key
    read -r -s -p "Please enter the id of the key you just created: " KEY_ID
    echo
    KEY_OUTPUT=$(gpg --armor --export "${KEY_ID}")

    cat << EOF
Please add the following public key to your Github profile:
${KEY_OUTPUT}
EOF
    read -r -p "when complete, hit enter"

    # Should prompt for password
    echo "test" | gpg --clear-sign > /dev/null

    # Need to get the signing
    # Expect there to be a line that looks like:
    # sec   rsa4096/<SIGNING_KEY> 2019-11-23 [SC]
    SIGNING_KEY=$(gpg --list-secret-keys --keyid-format LONG | grep 'sec' | awk '{print $2}' | awk -F'/' '{print $2}')
    git config --global commit.gpgsign true
    git config --global user.signingkey "${SIGNING_KEY}"
}

configure_git() {
    echo
    [[ $(ask_yes_no "configure git") -eq 0 ]] && return 0

    git config --global --replace-all "user.name" "Kevin Rosendahl"
    git config --global --replace-all "user.email" "kevindrosendahl@gmail.com"

    create_ssh_key
    configure_commit_signing
}

prompt_further_setup() {
  cat << EOF
Please configure the following options:

System Preferences
  - Display
    - Night Shift
      - Schedule: Custom
      - From 12:00 AM to 7:00 AM
      - Color Temperature: More Warm
  - Keyboard
    - Keyboard
      - Modifier Keys...
        - Caps Lock -> Escape
    - Shortcuts
      - Spotlight
        - Uncheck "Show Spotlight search"
  - Notifications
    - Uncheck "Show message preview"
    - Messages
      - Uncheck "Play sound for notifications"
  - Accessibility
    - Display
      - Check "Reduce motion"
EOF
  read -r -p "when complete, hit enter"
}

configure_services() {
    echo && echo "* configuring services"
    configure_hammerspoon
    configure_alfred
    configure_git
    prompt_further_setup
}

if ! command -v brew >/dev/null 2>&1; then
  cat >&2 <<'EOF'
homebrew is required but was not found on PATH.

Install it with:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Then re-run this script.
EOF
  exit 1
fi

install_brew_packages
set_options
sync
set_shell
configure_services
