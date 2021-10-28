pub mod install;
mod process;
mod prompt;
mod sync;

#[cfg(target_os = "linux")]
mod linux;

#[cfg(target_os = "macos")]
mod macos;
