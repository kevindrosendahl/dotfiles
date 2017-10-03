# Installation checklist:

## Install programs

```
./install.sh [-w] [-p]
```

## Follow platform specific checklist

- [OS X](#os-x-checklist)

## Install zprezto

```
zsh
```

```
git clone --recursive https://github.com/kevindrosendahl/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```

```
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
```

```
chsh -s /bin/zsh
```

## Add Github ssh key

```
ssh-keygen -t rsa -b 4096 -C "kevindrosendahl@gmail.com" -f ~/.ssh/id_rsa-github
cat ~/.ssh/id_rsa-github.pub
```

## OS X checklist

### System Preferences

- General
  - Appearance
    - Check "Use dark menu bar and Dock"
    - Check "Automatically hide and show the menu bar"
- Dock
  - Size ~20%
  - Position on screen: Left
  - Check "Automatically hide and show the Dock"
- Display
  - Night Shift
    - Schedule: Custom
    - From 12:00 AM to 7:00 AM
    - Color Temperature: More Warm
- Keyboard
  - Keyboard
    - Modifier Keys...
      - Caps Lock -> Escape
    - Customize Control Strip...
      - Default view
        - Remove Siri
      - Extended view
        - Remove Siri
        - Add Sleep to far right
  - Text
    - Remove "omw" shortcut
    - Uncheck
      - "Correct spelling automatically"
      - "Capitalize words automatically"
      - "Add period with double space"
  - Shortcuts
    - Spotlight
      - Uncheck "Show Spotlight search"
- Notifications
  - Uncheck "Show message preview"
- Security & Privacy
  - Require password -> immediately
- Trackpad
  - Check "Tap to click"

### Alfred

- General
  - Alfred Hotkey -> cmd+space
- Features
  - Uncheck "Contacts"
  - Check "Folders"
- Appearance
  - Alfred macOS Dark
  - Options
    - Check "Hide hat on Alfred window"

### Dropbox

Log in

### 1Password

Sync using Dropbox

### Chrome

- Set Google Chrome to be your default browser
- Sign in to Google account
- Hide unwanted extensions

### BetterTouchTool

- Load license from emailed receipt
- Advanced settings
  - Sync: Enable Dropbox Sync

### iTerm2

- iTerm2 -> Preferences
  - Check "Load preferences from custom folder or URL"
  - Navigate to ~, press cmd+shift+. to show dotfiles, click on .iterm2
- View -> Customize Touch Bar...
  - Remove everything

