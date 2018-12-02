use std::fs::{read_dir, File, OpenOptions};
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

impl Installer {
    pub(super) fn platform_install(&self) {
        self.install_apt_packages();
    }

    pub(super) fn platform_dotfiles(&self) -> PathBuf {
        self.dotfiles_repo().join("platform/linux/dotfiles")
    }

    pub(super) fn platform_symlink_dotfiles(&self) {
        let dotfiles_dir = self.dotfiles_repo().join("platform/linux/dotfiles");
        let home = Path::new(&self.home);
        for entry in read_dir(dotfiles_dir).unwrap() {
            let entry = entry.unwrap();
            let symlink_path = home.join(entry.file_name());
            if !symlink_path.exists() {
                symlink(entry.path(), symlink_path).unwrap();
            }
        }
    }

    fn install_apt_packages(&self) {
        println!("{}installing packages", emoji::PACKAGE);

        let spinner = ProgressBar::new_spinner();
        spinner.set_message("updating package list");
        spinner.enable_steady_tick(50);
        self.apt_update().wait().unwrap();
        spinner.finish_with_message(&format!("{} updated package list", emoji::CHECK));

        let packages = self.get_apt_packages();
        let progress = MultiProgress::new();
        let spinner = ProgressBar::new_spinner();
        let spinner = progress.add(spinner);

        let progress_bar = ProgressBar::new(packages.len() as u64);
        let progress_bar = progress.add(progress_bar);

        spinner.enable_steady_tick(50);
        progress_bar.inc(1);

        let handle = thread::spawn(move || progress.join());

        for (idx, package) in packages.iter().enumerate() {
            spinner.set_message(&format!("installing {}", package));
            self.apt_install(package).wait_with_output().unwrap();
            progress_bar.inc(1);
        }

        spinner.finish_with_message(&format!("{} installed packages", emoji::CHECK));
        progress_bar.finish_and_clear();

        handle.join().unwrap().unwrap();
    }

    fn get_apt_packages(&self) -> Vec<String> {
        let file =
            File::open(self.dotfiles_repo().join("platform/linux/apt-packages.txt")).unwrap();
        let file = BufReader::new(&file);
        file.lines()
            .map(|r| r.unwrap())
            .filter(|s| !s.starts_with("#"))
            .filter(|s| !s.is_empty())
            .collect()
    }

    fn apt_update(&self) -> Child {
        self.apt_command("update", vec![])
    }

    fn apt_install(&self, package: &str) -> Child {
        self.apt_command("install", vec!["-y", package])
    }

    fn apt_command(&self, command: &'static str, mut args: Vec<&str>) -> Child {
        args.insert(0, command);
        self.root_command("apt")
            .args(args)
            .stderr(Stdio::piped())
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .spawn()
            .unwrap()
    }
}
