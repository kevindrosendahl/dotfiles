use dirs::home_dir;
use git2::Repository;
use nix::unistd::{chown, Gid, Uid};

pub fn install() {
    clone_repo();
    install_platform();
}

fn clone_repo() {
    let repo_dir = home_dir()
        .unwrap()
        .join("src/github.com/kevindrosendahl/dotfiles");
    if repo_dir.exists() {
        return;
    }

    Repository::clone(
        "https://github.com/kevindrosendahl/dotfiles",
        repo_dir.clone(),
    )
    .expect("failed to clone repo");

    let uid = Uid::from_raw(users::get_current_uid());
    let gid = Gid::from_raw(users::get_current_gid());
    chown(&repo_dir, Some(uid), Some(gid)).expect("failed to chown repo");
}

#[cfg(target_os = "linux")]
fn install_platform() {
    crate::linux::install();
}

#[cfg(target_os = "macos")]
fn install_platform() {
    crate::macos::install();
}
