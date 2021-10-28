use human_panic::setup_panic;
use dotfiles::install::install;

fn main() {
    setup_panic!();
    install();
}
