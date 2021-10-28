use duct::cmd;
use std::env;
use std::ffi::OsString;
use std::io::Read;

const DRY_RUN_ENV_VAR: &'static str = "DOTFILES_DRY_RUN";

pub(crate) fn run<S>(description: &str, command: &str, args: S)
where
    S: IntoIterator,
    S::Item: Into<OsString>,
{
    if is_dry_run() {
        let args: Vec<String> = args
            .into_iter()
            .map(Into::<OsString>::into)
            .map(|s| s.into_string().unwrap())
            .collect();
        let args = args.join(" ");
        println!("would run command `{} {}`", command, args);
        return;
    }

    let mut handle = cmd(command, args)
        .stderr_to_stdout()
        .reader()
        .unwrap_or_else(|_| panic!("unable to launch {}", description));

    let mut buffer = String::new();
    let result = handle.read_to_string(&mut buffer);
    match result {
        Ok(_) => {}
        Err(_) => {
            println!("error {}: \n{}", description, buffer);
            panic!();
        }
    }
}

pub(crate) fn run_with_spinner<S>(
    description: &'static str,
    finished_message: &'static str,
    command: &str,
    args: S,
) where
    S: IntoIterator,
    S::Item: Into<OsString>,
{
    let spinner = crate::prompt::spinner(description);
    run(description, command, args);
    spinner.finish_with_message(finished_message);
}

pub(crate) fn ask_for_root() {
    if is_dry_run() {
        println!("would ask for sudo");
        return
    }

    cmd!("sudo", "-v").run().unwrap();
}

pub(crate) fn run_as_root<S>(command: &str, args: S)
where
    S: IntoIterator,
    S::Item: Into<String>,
{
    let mut sudo_args = vec![command.to_string()];
    sudo_args.append(&mut args.into_iter().map(|s| s.into()).collect());
    run("running sudo command", "sudo", &sudo_args);
}

fn is_dry_run() -> bool {
    if let Ok(dry_run) = env::var(DRY_RUN_ENV_VAR) {
        let dry_run: i32 = dry_run.parse().unwrap();
        return dry_run > 0
    }

    false
}
