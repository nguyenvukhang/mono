use std::path::PathBuf;

use argh::FromArgs;

#[derive(FromArgs, Debug)]
/// Resolves the shortened file.
#[argh(subcommand, name = "resolve")]
pub struct Resolve {
    #[argh(positional)]
    pub args: Vec<String>,
}

#[derive(FromArgs, Debug)]
/// Lists all pdfs in the directories.
#[argh(subcommand, name = "ls")]
pub struct List {
    #[argh(positional)]
    pub dirs: Vec<PathBuf>,
}

#[derive(FromArgs, Debug)]
#[argh(subcommand)]
pub enum Subcommand {
    List(List),
    Resolve(Resolve),
}

#[derive(FromArgs, Debug)]
/// Top-level CLI.
pub struct Cli {
    #[argh(subcommand)]
    pub subcommand: Subcommand,
}

pub fn parse() -> Cli {
    argh::from_env()
}
