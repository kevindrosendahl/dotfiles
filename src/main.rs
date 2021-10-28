use human_panic::setup_panic;
use sysctl::Sysctl;

fn main() {
    setup_panic!();
    println!(
        "{}",
        sysctl::Ctl::new("sysctl.proc_translated")
            .unwrap()
            .value()
            .unwrap()
    );
}
