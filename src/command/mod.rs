pub mod install;

#[cfg(target_os = "macos")]
mod install_macos;

#[cfg(target_os = "linux")]
mod install_linux;

use self::install::install;

#[derive(Debug, StructOpt)]
pub enum Command {
    #[structopt(name = "install")]
    Install {
        #[structopt(long = "uid", short = "u")]
        uid: u32,
    },
}

pub fn run_dotfiles(command: Command) {
    match command {
        Command::Install { uid } => install(uid),
    }
}
