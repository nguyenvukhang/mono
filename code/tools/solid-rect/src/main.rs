use std::fs::File;
use std::io::BufWriter;

use png::{BitDepth, ColorType, Encoder};

const WIDTH: u32 = 64;
const HEIGHT: u32 = WIDTH;
const N: usize = WIDTH as usize * HEIGHT as usize * 3;

const fn hex_b(b: u8) -> u8 {
    match b {
        b'0'..=b'9' => b - b'0',
        b'a'..=b'f' => b - b'a' + 10,
        _ => panic!("Invalid character"),
    }
}

const fn hex(bytes: &[u8; 7]) -> u32 {
    let b'#' = bytes[0] else { panic!("hex code should start with a '#'.") };
    let mut j = 0;
    let mut c = 0;
    while j < 6 {
        j += 1;
        c |= (hex_b(bytes[j]) as u32) << (6 - j) * 4;
    }
    c
}

#[allow(unused)]
mod colors {
    use super::*;

    pub const CARDBOARD_BROWN: u32 = hex(b"#dea66c");

    mod github {
        use super::*;

        pub const CPP: u32 = hex(b"#f34b7d");
        pub const RUST: u32 = hex(b"#dea584");
    }
}

#[test]
fn test_hex() {
    for n in 0..=0xffffff {
        let s = format!("#{:0>6x}", n);
        let s = s.as_bytes();
        assert_eq!(hex(s.try_into().unwrap()), n);
    }
}

const COLOR: u32 = colors::CARDBOARD_BROWN;

const R: u8 = ((COLOR & 0xff0000) >> 16) as u8;
const G: u8 = ((COLOR & 0x00ff00) >> 8) as u8;
const B: u8 = ((COLOR & 0x0000ff) >> 0) as u8;

fn build_data() -> Vec<u8> {
    let mut buf = Vec::with_capacity(N);
    buf.resize(N, 0);
    for i in 0..N {
        match i % 3 {
            0 => buf[i] = R,
            1 => buf[i] = G,
            2 => buf[i] = B,
            _ => continue,
        }
    }
    buf
}

fn main() {
    let file = File::create("output.png").unwrap();
    let writer = BufWriter::new(file);
    let mut encoder = Encoder::new(writer, WIDTH, HEIGHT);
    encoder.set_color(ColorType::Rgb);
    encoder.set_depth(BitDepth::Eight);
    let mut writer = encoder.write_header().unwrap();
    let data = build_data();
    writer.write_image_data(&data).unwrap(); // Save
}
