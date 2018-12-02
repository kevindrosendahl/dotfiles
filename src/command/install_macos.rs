use std::fs::read_dir;
use std::io::{BufRead, BufReader, Write};
use std::os::unix::fs::symlink;
use std::os::unix::process::CommandExt;
use std::path::{Path, PathBuf};
use std::process::{Child, Stdio};
use std::sync::Arc;
use std::thread;
use std::time::Duration;

use super::install::Installer;
use crate::util::emoji;

use dialoguer::{theme::ColorfulTheme, Checkboxes};
use indicatif::{MultiProgress, ProgressBar, ProgressStyle};

static BREW_INSTALL_URL: &'static str =
    "https://raw.githubusercontent.com/Homebrew/install/master/install";

impl Installer {
    pub(super) fn platform_install(&self) {
        self.install_brew_packages();
    }

    pub(super) fn platform_dotfiles(&self) -> PathBuf {
        self.dotfiles_repo().join("platform/macOS/dotfiles")
    }

    fn install_brew_packages(&self) {
        self.install_brew();

        println!("installing brew packages");
        self.user_command("brew")
            .args(&[
                "bundle",
            ])
            .current_dir(self.dotfiles_repo().join("platform/macOS"))
            .spawn()
            .unwrap()
            .wait()
            .unwrap();
    }

    fn install_brew(&self) {
        println!("checking for brew installation");
        match which::which("brew") {
            Ok(_) => (),
            Err(err) => match err.kind() {
                which::ErrorKind::CannotFindBinaryPath => self.install_brew_impl(),
                _ => panic!(err),
            },
        }
    }

    fn install_brew_impl(&self) {
        println!("installing brew");
        let installer = reqwest::get(BREW_INSTALL_URL).unwrap().text().unwrap();
        let mut ruby = self
            .user_command("ruby")
            .stdin(Stdio::piped())
            .spawn()
            .unwrap();
        let mut stdin = ruby.stdin.as_mut().unwrap();
        stdin.write_all(installer.as_bytes()).unwrap();
        ruby.wait().unwrap();
    }
}
