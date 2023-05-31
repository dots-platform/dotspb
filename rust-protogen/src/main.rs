// Copyright 2023 The Dots Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

use tonic_build;

const PROTOS_DIR: &str = "../protos";
const RUST_DIR: &str = "../rust";

fn main() {
    let paths_iter = std::fs::read_dir(PROTOS_DIR)
        .unwrap()
        .map(|entry| entry.unwrap().file_name().to_owned())
        .filter(|path| path.to_str().unwrap().ends_with(".proto"));
    let paths = Vec::from_iter(paths_iter);

    tonic_build::configure()
        .build_server(true)
        .out_dir(Path::new(RUST_DIR).join("src").to_str().unwrap())
        .compile(paths.as_slice(), &[PROTOS_DIR])
        .unwrap();

    let mut lib_file = File::create(Path::new(RUST_DIR).join("src").join("lib.rs")).unwrap();
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
    }
}
