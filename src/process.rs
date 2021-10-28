use duct::cmd;
use std::ffi::OsString;
use std::io::Read;

pub(crate) fn run<S>(description: &str, command: &str, args: S)
where
    S: IntoIterator,
    S::Item: Into<OsString>,
{
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
