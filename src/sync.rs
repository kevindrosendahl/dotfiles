use std::fs::read_dir;
use std::path::{Path, PathBuf};

pub(crate) fn sync_dotfiles(dir: &Path) {
    let files: Vec<PathBuf> = read_dir(dir)
        .unwrap()
        .map(|entry| entry.unwrap().path())
        .collect();

    for file in files {
        let dest = if file.is_dir() {
            dirs::home_dir().unwrap()
        } else {
            dirs::home_dir().unwrap().join(file.file_name().unwrap())
        };
        let dest = dest.as_os_str().to_str().unwrap();
        let file_path = file.as_os_str().to_str().unwrap().to_string();

        crate::process::run(
            format!("symlink {}", file_path).as_str(),
            "ln",
            vec!["-sfF", file_path.as_str(), dest],
        );
    }
}
