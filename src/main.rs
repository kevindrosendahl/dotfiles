use dotfiles::install::install;
use human_panic::setup_panic;

fn main() {
    setup_panic!();
    install();
}
