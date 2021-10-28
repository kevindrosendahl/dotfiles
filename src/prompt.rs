use console::Emoji;
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
