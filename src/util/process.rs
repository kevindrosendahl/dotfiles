use std::os::unix::process::CommandExt;
use std::process::Command;

pub fn root_command(program: &str) -> Command {
    Command::new(program)
}

pub fn user_command(program: &str, uid: u32) -> Command {
    let mut command = Command::new(program);
    command.uid(uid);
    command
}
