use std::io;
use std::path::Path;

use argh::FromArgs;

macro_rules! git {
    ($($arg:expr),*) => { std::process::Command::new("git")$(.arg($arg))* };
}

/// All git statuses.
#[derive(FromArgs)]
struct Ags {
    /// how deep to go.
    #[argh(option, default = "5")]
    depth: usize,

    /// print repos even if clean.
    #[argh(switch, short = 'q')]
    quiet: bool,

    /// use a different search root.
    #[argh(option, short = 'C')]
    root: Option<String>,
}

impl Ags {
    const fn root(&self) -> &str {
        match self.root {
            Some(ref v) => v.as_str(),
            None => ".",
        }
    }

    fn handle_git_repo(&self, abs_path: &Path) {
        let output = git!("-C", abs_path, "status", "--porcelain").output().unwrap();
        let git_status_is_clean = output.stdout.trim_ascii().is_empty();
        let disp = abs_path.display();
        match (self.quiet, git_status_is_clean) {
            (_, false) => println!("\x1b[36m> \x1b[33m{}\x1b[m", disp),
            (false, true) => println!("\x1b[36m> \x1b[37m{}\x1b[m", disp),
            _ => {}
        }
        if !git_status_is_clean {
            println!("---");
            git!("-C", abs_path, "status").spawn().unwrap().wait().unwrap();
            println!("---");
        }
    }
}

#[inline]
fn is_in_git_dir(path: &Path) -> io::Result<bool> {
    git!("-C", path, "rev-parse", "--git-dir").output().map(|v| v.status.success())
}

fn path_ends_with(mut path: &Path, components: &[&str]) -> bool {
    if components.is_empty() {
        return true;
    }
    let mut j = components.len();
    loop {
        j -= 1;
        if !path.ends_with(components[j]) {
            return false;
        }
        if j > 0 {
            let Some(parent) = path.parent() else { return false };
            path = parent;
        } else {
            // j == 0
            return true;
        }
    }
}

#[test]
fn path_ends_with_test() {
    let path = Path::new("/a/b/c/d");
    assert!(path_ends_with(path, &["d"]));
    assert!(path_ends_with(path, &["c", "d"]));
    assert!(path_ends_with(path, &["b", "c", "d"]));
    assert!(path_ends_with(path, &["a", "b", "c", "d"]));
}

fn main() {
    let ags: Ags = argh::from_env();

    let root = ags.root();
    let mut it =
        walkdir::WalkDir::new(root).into_iter().filter_entry(|v| v.file_type().is_dir());

    while let Some(entry) = it.next() {
        let entry = match entry {
            Ok(v) => v,
            Err(err) => panic!("ERROR: {}", err),
        };
        if entry.path_is_symlink()
            || entry.depth() > ags.depth
            || path_ends_with(entry.path(), &[".local", "share", "nvim"])
            || path_ends_with(entry.path(), &[".cargo", "git"])
        {
            it.skip_current_dir();
            continue;
        }
        if let Ok(true) = is_in_git_dir(entry.path()) {
            let path = entry.path();
            let path = path.strip_prefix(root).unwrap_or(path);
            ags.handle_git_repo(path);
            it.skip_current_dir();
        }
    }
}
