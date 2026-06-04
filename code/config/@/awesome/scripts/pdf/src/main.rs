use std::path::{Path, PathBuf};
use walkdir::WalkDir;

/// Number of components to display.
const N: usize = 4;

/// https://davatorium.github.io/rofi/1.7.3/rofi-script.5/
/// This tells us that the `info` component shall be used to update
/// $ROFI_INFO.
fn rofi(abbrev: &Path, actual: &Path) {
    println!("{}\0info\x1f{}", abbrev.display(), actual.display());
}

fn fzf_custom(abbrev: &Path, actual: &Path) {
    println!("{}:{}", abbrev.display(), actual.display());
}

fn main() {
    let files = std::env::args_os().skip(1).flat_map(WalkDir::new);

    let mut abbrev_buf = PathBuf::with_capacity(N);

    for file in files {
        let Ok(file) = file else { continue };
        let pdf = match file.path().extension() {
            Some(v) if v == "pdf" => file.path(),
            _ => continue,
        };

        let components = pdf.components().collect::<Vec<_>>();
        let n = components.len();
        if n < N {
            println!("{}", pdf.display());
            continue;
        }
        // Beyond here, n ≥ N.
        abbrev_buf.clear();
        abbrev_buf.extend(&components[n - N..]);

        // rofi(abbrev_buf.as_path(), pdf);
        fzf_custom(abbrev_buf.as_path(), pdf);
    }
}
