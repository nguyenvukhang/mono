use super::prelude::*;

/// Download and install libgit2 libraries.
#[derive(FromArgs)]
#[argh(subcommand, name = "libgit2")]
pub struct Libgit2 {}

macro_rules! version {
    ($version:expr) => {
        const SOURCE_URL: &str = concat!(
            "https://github.com/libgit2/libgit2/archive/refs/tags/v",
            $version,
            ".zip",
        );
        const ZIP_DIR: &str = concat!("libgit2-", $version);
    };
}
version!("1.9.4");

impl Target for Libgit2 {
    fn install(&self) {
        const TMP_ZIP: &str = "libgit2.zip";

        // Download and extract the zip file.
        utils::curl(TMP_ZIP, SOURCE_URL);
        sh!("unzip", TMP_ZIP);
        let _ = fs::remove_file(TMP_ZIP);

        const PREFIX_FLAG: &str = "-DCMAKE_INSTALL_PREFIX=/usr";
        cmd!("cmake", PREFIX_FLAG, "-B", "build", "-S", ".", "-G", "Ninja")
            .current_dir(ZIP_DIR)
            .run()
            .unwrap();
        cmd!("cmake", "--build", "build").current_dir(ZIP_DIR).run().unwrap();
        cmd!("sudo", "cmake", "--install", "build").current_dir(ZIP_DIR).run().unwrap();

        let _ = fs::remove_dir_all(ZIP_DIR);
    }
}
