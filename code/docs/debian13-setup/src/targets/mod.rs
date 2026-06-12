use crate::target::Target;

use argh::FromArgs;

macro_rules! export_module {
    ($module:ident) => {
        mod $module;
        #[allow(unused)]
        pub use $module::*;
    };
    ($(($module:ident, $struct:ident)),* $(,)?) => {
        $(
            mod $module;
            #[allow(unused)]
            pub use $module::$struct;
        )*

        #[derive(FromArgs)]
        #[argh(subcommand)]
        pub enum SubcommandTarget {
            $($struct($struct)),*
        }

        impl Target for SubcommandTarget {
            fn run(&self) {
                match self {$(
                    Self::$struct(v) => {
                        println!("\x1b[35mRunning target: {}\x1b[m", stringify!($module));
                        v.run();
                    }
                ),*}
            }

            fn install(&self) {}
        }
    };
}

mod prelude {
    pub(crate) use crate::git::GitRepo;
    pub(crate) use crate::target::Target;
    pub(crate) use crate::{dirs, pins, utils};

    pub(crate) use argh::FromArgs;

    pub(crate) use std::path::PathBuf;
    pub(crate) use std::{env, fs};
}

export_module!(
    (apt, Apt),
    (clangd, Clangd),
    (disable_nouveau, DisableNouveau),
    (dwm, Dwm),
    (firefox, Firefox),
    (less, Less),
    (libgit2, Libgit2),
    (ln, Ln),
    (micromamba, Micromamba),
    (minisign, Minisign),
    (n, NTheNodeVersionManager),
    (neovim, Neovim),
    (nvidia, Nvidia),
    (qmk, Qmk),
    (yubikey, Yubikey),
    (zls, Zls),
);

#[derive(FromArgs)]
/// Top-level command.
pub struct TopLevel {
    #[argh(subcommand)]
    pub target: SubcommandTarget,
}

pub fn parse_cli() -> TopLevel {
    return argh::from_env();
}
