use crate::{
    process::{ask_for_root, run, run_as_root, run_with_spinner},
    prompt::{header, wait_for_complete, BEER, COMPUTER},
    sync::sync_dotfiles,
};
use std::path::Path;
use duct::cmd;

#[cfg(target_arch = "arm")]
const BREW: &str = "/opt/homebrew/bin/brew";

#[cfg(target_arch = "arm")]
const BREW_PATH: &str = "/opt/homebrew/bin";

#[cfg(target_arch = "x86_64")]
const BREW: &str = "/usr/local/bin/brew";

#[cfg(target_arch = "x86_64")]
const BREW_PATH: &str = "/usr/local/bin";

pub(crate) fn install() {
    install_brew();
    set_options();
    sync_dotfiles(
        dirs::home_dir()
            .unwrap()
            .join("src/github.com/kevindrosendahl/dotfiles/macOS/dotfiles")
            .as_path(),
    );
    set_shell();
    configure_services();
}

fn install_brew() {
    println!(
        "{} {}",
        header("installing homebrew and homebrew packages"),
        BEER
    );

    run_with_spinner(
        "installing brew",
        "finished installing brew",
        "/bin/bash",
        vec![
        "-c",
        "\"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\""
    ],
    );

    run_with_spinner(
        "installing brew packages",
        "finished installing brew packages",
        BREW,
        vec!["bundle"],
    );
}

fn set_options() {
    println!(
        "\n{} {}",
        header("setting options (may require restart to take effect)"),
        COMPUTER
    );

    // Ask for admin password up front.
    ask_for_root();

    // Disable the sound effects on boot.
    run_as_root("nvram", vec!["SystemAudioVolume=\" \""]);

    // Restart automatically if the computer freezes.
    run_as_root("systemsetup", vec!["-setrestartfreeze", "on"]);

    // Set system defaults. Mostly derived from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
    let mut defaults = vec![
        Default::builder()
            .description("enable dark interface")
            .domain("NSGlobalDomain")
            .key("AppleInterfaceStyle")
            .value(DefaultValue::String("Dark"))
            .build(),
        Default::builder()
            .description("set key repeat preferences")
            .domain("NSGlobalDomain")
            .key("InitialKeyRepeat")
            .value(DefaultValue::Int(15))
            .build(),
        Default::builder()
            .description("set key repeat preferences")
            .domain("NSGlobalDomain")
            .key("KeyRepeat")
            .value(DefaultValue::Int(1))
            .build(),
        Default::builder()
            .description("disable automatic capitalization")
            .domain("NSGlobalDomain")
            .key("NSAutomaticCapitalizationEnabled")
            .value(DefaultValue::Bool(false))
            .build(),
        Default::builder()
            .description("disable smart dashes")
            .domain("NSGlobalDomain")
            .key("NSAutomaticCapitalizationEnabled")
            .value(DefaultValue::Bool(false))
            .build(),
        Default::builder()
            .description("disable automatic period substitution")
            .domain("NSGlobalDomain")
            .key("NSAutomaticPeriodSubstitutionEnabled")
            .value(DefaultValue::Bool(false))
            .build(),
        Default::builder()
            .description("disable smart quotes")
            .domain("NSGlobalDomain")
            .key("NSAutomaticQuoteSubstitutionEnabled")
            .value(DefaultValue::Bool(false))
            .build(),
        Default::builder()
            .description("disable auto-correct")
            .domain("NSGlobalDomain")
            .key("NSAutomaticSpellingCorrectionEnabled")
            .value(DefaultValue::Bool(false))
            .build(),
        Default::builder()
            .description("enable tap to click")
            .domain("com.apple.driver.AppleBluetoothMultitouch.trackpad")
            .key("Clicking")
            .value(DefaultValue::Bool(true))
            .build(),
        Default::builder()
            .description("enable tap to click")
            .current_host()
            .domain("NSGlobalDomain")
            .key("com.apple.mouse.tapBehavior")
            .value(DefaultValue::Int(1))
            .build(),
        Default::builder()
            .description("enable tap to click")
            .domain("NSGlobalDomain")
            .key("com.apple.mouse.tapBehavior")
            .value(DefaultValue::Int(1))
            .build(),
        Default::builder()
            .description("require password after sleep")
            .domain("com.apple.screensaver")
            .key("askForPassword")
            .value(DefaultValue::Int(1))
            .build(),
        Default::builder()
            .description("require password after sleep")
            .domain("com.apple.screensaver")
            .key("askForPasswordDelay")
            .value(DefaultValue::Int(0))
            .build(),
        Default::builder()
            .description("show hidden files in finder by default")
            .domain("com.apple.finder")
            .key("AppleShowAllFiles")
            .value(DefaultValue::Bool(true))
            .build(),
        Default::builder()
            .description("display full POSIX path as Finder window title")
            .domain("com.apple.finder")
            .key("_FXShowPosixPathInTitle")
            .value(DefaultValue::Bool(true))
            .build(),
        Default::builder()
            .description("avoid creating .DS_Store files on network volumes")
            .domain("com.apple.desktopservices")
            .key("DSDontWriteNetworkStores")
            .value(DefaultValue::Bool(true))
            .build(),
        Default::builder()
            .description("avoid creating .DS_Store files on USB volumes")
            .domain("com.apple.desktopservices")
            .key("DSDontWriteUSBStores")
            .value(DefaultValue::Bool(true))
            .build(),
        Default::builder()
            .description("wipe default app icons from Dock")
            .domain("com.apple.dock")
            .key("persistent-apps")
            .value(DefaultValue::Array(vec![]))
            .build(),
        Default::builder()
            .description("orient the doc on the left")
            .domain("com.apple.dock")
            .key("orientation")
            .value(DefaultValue::String("left"))
            .build(),
        Default::builder()
            .description("set dock icon size to 30 px")
            .domain("com.apple.dock")
            .key("tilesize")
            .value(DefaultValue::Int(30))
            .build(),
        Default::builder()
            .description("remove dock auto-hiding delay")
            .domain("com.apple.dock")
            .key("autohide-delay")
            .value(DefaultValue::Float(0f32))
            .build(),
        Default::builder()
            .description("remove animation when hiding/showing the dock")
            .domain("com.apple.dock")
            .key("autohide-time-modifier")
            .value(DefaultValue::Float(0f32))
            .build(),
        Default::builder()
            .description("auto hide the dock")
            .domain("com.apple.dock")
            .key("autohide")
            .value(DefaultValue::Int(1))
            .build(),
        Default::builder()
            .description("auto hide the menu bar")
            .domain("NSGlobalDomain")
            .key("_HIHideMenuBar")
            .value(DefaultValue::Bool(true))
            .build(),
        Default::builder()
            .description("speed up mission control animations")
            .domain("com.apple.dock")
            .key("expose-animation-duration")
            .value(DefaultValue::Float(0.1))
            .build(),
        Default::builder()
            .description("set control strip defaults")
            .domain("com.apple.controlstrip")
            .key("FullCustomized")
            .value(DefaultValue::Array(vec![
                "com.apple.system.group.brightness",
                "com.apple.system.group.keyboard-brightness",
                "com.apple.system.group.media",
                "com.apple.system.group.volume",
                "com.apple.system.screen-lock",
            ]))
            .build(),
        Default::builder()
            .description("set control strip defaults")
            .domain("com.apple.controlstrip")
            .key("MiniCustomized")
            .value(DefaultValue::Array(vec![
                "com.apple.system.brightness",
                "com.apple.system.mute",
                "com.apple.system.volume",
            ]))
            .build(),
        Default::builder()
            .description("show battery percentage in the menu bar")
            .domain("com.apple.menuextra.battery")
            .key("ShowPercent")
            .value(DefaultValue::String("YES"))
            .build(),
    ];

    let mut hot_corner_defaults = vec![
        "wvous-tl-corner",
        "wvous-tl-modifier",
        "wvous-tr-corner",
        "wvous-tr-modifier",
        "wvous-bl-corner",
        "wvous-bl-modifier",
        "wvous-br-corner",
        "wvous-br-modifier",
    ]
    .iter()
    .map(|key| {
        Default::builder()
            .description("disable hot corners")
            .domain("com.apple.dock")
            .key(key)
            .value(DefaultValue::Int(0))
            .build()
    })
    .collect();

    defaults.append(&mut hot_corner_defaults);

    for default in defaults.into_iter() {
        let mut args = Vec::new();
        if let Some(option) = default.option {
            args.push(option);
        }
        args.append(&mut vec!["write".to_string(), default.domain, default.key]);
        args.append(&mut default.value.to_args());

        run(
            format!("setting default ({})", default.description).as_str(),
            "defaults",
            args,
        );
    }

    // Kill effected apps.
    let effected_apps = vec!["Activity Monitor", "Dock", "Finder", "SystemUIServer"];
    for app in effected_apps {
        run(format!("killing {}", app).as_str(), "killall", vec![app]);
    }

    println!("finished setting options");
}

fn set_shell() {
    println!("\n{}", header("configuring zsh to be default shell"));

    let zsh = which::which_in("zsh", Some(Path::new(BREW_PATH)), Path::new("/")).unwrap();
    let zsh = zsh.to_str().unwrap();
    let shells = std::fs::read_to_string("/etc/shells").unwrap();
    if !shells.lines().any(|shell| shell.eq(zsh)) {
        run_as_root(
            "sh",
            vec!["-c", format!("'echo {} >> /etc/shells'", zsh).as_str()],
        )
    }

    run_as_root(
        "chsh",
        vec![
            "-s",
            zsh,
            users::get_current_username().unwrap().to_str().unwrap(),
        ],
    );
}

fn configure_services() {
    configure_hammerspoon();
    configure_alfred();
    configure_git();
}

fn configure_hammerspoon() {
    println!("\n{}", header("configuring hammerspoon"));
    run(
        "opening hammerspoon",
        "open",
        vec!["/Applications/Hammerspoon.app"],
    );
    println!(
        "Please configure the following options for hammerspoon:
  - enable Launch Hammerspoon at login
  - enable Show menu item
  - disable Show dock icon
  - Enable Accessibility"
    );

    wait_for_complete();
}

fn configure_alfred() {
    println!("\n{}", header("configuring alfred"));
    run(
        "opening hammerspoon",
        "open",
        vec!["/Applications/Alfred 4.app"],
    );
    println!(
        "Please configure the following options for Alfred:
  General:
    - enable Launch Alfred at login
    - set Alfred Hotkey to cmd + space
  Appearance:
    - Alfred macOS Dark"
    );

    wait_for_complete();
}

fn configure_git() {
    create_ssh_key();
}

fn create_ssh_key() {
    let now = chrono::Local::now();
    let now = now.format("%m%d%y");
    let key_path = dirs::home_dir().unwrap().join(format!(".ssh/id_ed25519-github-{}", now));
    run("generating ssh key", "ssh-keygen", vec!["-o", "-a" "100", "-t"]);


    // KEY_PATH=~/.ssh/id_ed25519-github-${DATESTAMP}
    // ssh-keygen -o -a 100 -t ed25519 -f ${KEY_PATH} -C kevindrosendahl@gmail.com
    //
    // PUBLIC_KEY=$(cat "${KEY_PATH}.pub")
    // cat << EOF
    // Please add the following public key to your Github profile:
    // ${PUBLIC_KEY}
    // EOF
    // read -p "when complete, hit enter"
}

#[derive(Clone)]
enum DefaultValue {
    Array(Vec<&'static str>),
    Bool(bool),
    Float(f32),
    Int(u32),
    String(&'static str),
}

impl DefaultValue {
    fn to_args(&self) -> Vec<String> {
        match self {
            DefaultValue::Array(a) => {
                let mut s = vec!["-array".to_string()];
                let mut args = a.iter().map(|s| format!("'{}'", s)).collect();
                s.append(&mut args);
                s
            }
            DefaultValue::Bool(b) => vec!["-bool".to_string(), b.to_string()],
            DefaultValue::Float(f) => vec!["-float".to_string(), f.to_string()],
            DefaultValue::Int(i) => vec!["-int".to_string(), i.to_string()],
            DefaultValue::String(s) => vec!["-string".to_string(), format!("'{}'", s)],
        }
    }
}

struct Default {
    description: &'static str,
    option: Option<String>,
    domain: String,
    key: String,
    value: DefaultValue,
}

impl Default {
    fn builder() -> DefaultBuilder {
        DefaultBuilder::new()
    }
}

struct DefaultBuilder {
    description: Option<&'static str>,
    option: Option<&'static str>,
    domain: Option<&'static str>,
    key: Option<&'static str>,
    value: Option<DefaultValue>,
}

impl DefaultBuilder {
    fn new() -> Self {
        DefaultBuilder {
            description: None,
            option: None,
            domain: None,
            key: None,
            value: None,
        }
    }

    fn description(self, description: &'static str) -> Self {
        DefaultBuilder {
            description: Some(description),
            option: self.option,
            domain: self.domain,
            key: self.key,
            value: self.value,
        }
    }

    fn current_host(self) -> Self {
        DefaultBuilder {
            description: self.description,
            option: Some("-currentHost"),
            domain: self.domain,
            key: self.key,
            value: self.value,
        }
    }

    fn domain(self, domain: &'static str) -> Self {
        DefaultBuilder {
            description: self.description,
            option: self.option,
            domain: Some(domain),
            key: self.key,
            value: self.value,
        }
    }

    fn key(self, key: &'static str) -> Self {
        DefaultBuilder {
            description: self.description,
            option: self.option,
            domain: self.domain,
            key: Some(key),
            value: self.value,
        }
    }

    fn value(self, value: DefaultValue) -> Self {
        DefaultBuilder {
            description: self.domain,
            option: self.option,
            domain: self.domain,
            key: self.key,
            value: Some(value),
        }
    }

    fn build(&self) -> Default {
        Default {
            description: self.description.unwrap(),
            option: self.option.map(|s| s.to_string()),
            domain: self.domain.unwrap().to_string(),
            key: self.key.unwrap().to_string(),
            value: self.value.clone().unwrap(),
        }
    }
}
