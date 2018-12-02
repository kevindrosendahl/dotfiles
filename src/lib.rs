#[macro_use]
extern crate structopt;

pub mod command;
pub mod util;

#[derive(Debug, StructOpt)]
pub struct Cli {
    #[structopt(subcommand)]
    pub cmd: command::Command,
}
