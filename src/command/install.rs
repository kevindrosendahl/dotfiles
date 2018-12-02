use std::env;
use std::fs::{create_dir_all, read_dir};
use std::os::unix::fs::symlink;
use std::path::{Path, PathBuf};
use std::process::Command;

use crate::util::process::{root_command, user_command};

use git2::Repository;

const HOME_ENV_VAR: &'static str = "HOME";
const REMOTE_ORIGIN: &'static str = "origin";

pub fn install(uid: u32) {
    let home = &env::var(HOME_ENV_VAR).unwrap();
    let installer = Installer {
        uid,
        home: home.to_string(),
    };
    installer.install();
}

pub(super) struct Installer {
    uid: u32,
    pub(super) home: String,
}

impl Installer {
    pub fn install(&self) {
        self.platform_install();

        self.clone_dotfiles_repo();

        self.symlink_dotfiles();
    }

    fn clone_dotfiles_repo(&self) {
        println!();
        let repo_dir = self.dotfiles_repo();
        if !repo_dir.exists() {
            println!("cloning kevindrosendahl/dotfiles");
            // TODO: setuid/setgid or chown after cloning
            Repository::clone("https://github.com/kevindrosendahl/dotfiles", repo_dir).unwrap();
        }
    }

    fn symlink_dotfiles(&self) {
        println!();
        let dotfiles_dirs = vec![
            self.dotfiles_repo().join("dotfiles"),
            self.platform_dotfiles(),
        ];
        let home = Path::new(&self.home);

        for dotfiles_dir in dotfiles_dirs {
            for entry in read_dir(dotfiles_dir).unwrap() {
                let entry = entry.unwrap();
                let symlink_path = home.join(entry.file_name());
                if !symlink_path.exists() {
                    symlink(entry.path(), symlink_path).unwrap();
                }
            }
        }
    }

    pub(super) fn dotfiles_repo(&self) -> PathBuf {
        Path::new(&self.home).join("src/github.com/kevindrosendahl/dotfiles")
    }

    pub(super) fn root_command(&self, program: &str) -> Command {
        root_command(program)
    }

    pub(super) fn user_command(&self, program: &str) -> Command {
        user_command(program, self.uid)
    }
}
