use console::Emoji;
use dialoguer::Input;
use indicatif::{ProgressBar, ProgressStyle};

pub static BEER: Emoji = Emoji("🍺", "");
pub static COMPUTER: Emoji = Emoji("💻", "");

pub(crate) fn spinner(message: &'static str) -> ProgressBar {
    let pb = ProgressBar::new_spinner().with_message(message);
    pb.set_style(
        ProgressStyle::default_spinner()
            .tick_strings(&["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"])
            .template("{spinner:.blue} {msg}"),
    );
    pb.enable_steady_tick(80);
    pb
}

pub(crate) fn wait_for_complete() {
    Input::<String>::new()
        .with_prompt("when complete, hit enter")
        .allow_empty(true)
        .interact()
        .unwrap();
}

pub(crate) fn header(message: &str) -> String {
    console::Style::new()
        .bold()
        .green()
        .apply_to(message)
        .to_string()
}
