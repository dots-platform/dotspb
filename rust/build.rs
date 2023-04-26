use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

fn main() {
    let paths_iter = std::fs::read_dir("../protos")
        .unwrap()
        .map(|entry| entry.unwrap().file_name().to_owned())
        .filter(|path| path.to_str().unwrap().ends_with(".proto"));
    let paths = Vec::from_iter(paths_iter);

    tonic_build::configure()
        .build_server(true)
        .out_dir("./src")
        .compile(paths.as_slice(), &["../protos"])
        .unwrap();

    let mut lib_file = File::create("./src/lib.rs").unwrap();
    for path in &paths {
        let mod_name = Path::new(path)
            .components()
            .last()
            .unwrap()
            .as_os_str()
            .to_str()
            .unwrap()
            .strip_suffix(".proto")
            .unwrap()
            .to_owned();
        lib_file.write_all(format!("pub mod {};\n", mod_name).as_bytes())
            .unwrap();
        println!("cargo:rerun-if-changed={}", path.to_str().unwrap());
    }
}
