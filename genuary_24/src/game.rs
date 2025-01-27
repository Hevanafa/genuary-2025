use std::io;
use std::io::Write;
use raylib::prelude::*;

const WW: i32 = 640;
const WH: i32 = 360;

/// h, s, v: 0.0..1.0
fn hsv2rgb(h: f32, s: f32, v: f32) -> (i32, i32, i32) {
	let (mut r, mut g, mut b) = (
		0.0, 0.0, 0.0);

	let i = (h * 6.0).floor();
	let f = h * 6.0 - i;
	let p = v * (1.0 - s);
	let q = v * (1.0 - f * s);
	let t = v * (1.0 - (1.0 - f) * s);

	match (i as i32) % 6 {
		0 => { r = v; g = t; b = p },
		1 => { r = q; g = v; b = p },
		2 => { r = p; g = v; b = t },
		3 => { r = p; g = q; b = v },
		4 => { r = t; g = p; b = v },
		5 => { r = v; g = p; b = q },
		_ => ()
	};

	((r * 255.0).round() as i32, (g * 255.0).round() as i32, (b * 255.0).round() as i32)
}


fn tri(d: &mut RaylibDrawHandle,
	x1: f32, y1: f32,
	x2: f32, y2: f32,
	x3: f32, y3: f32, colour: Color) {

	d.draw_triangle(Vector2::new(x1, y1), Vector2::new(x2, y2), Vector2::new(x3, y3), colour);
}

/// the same as `tri()` but uses i32
fn tri_i(d: &mut RaylibDrawHandle,
	x1: i32, y1: i32,
	x2: i32, y2: i32,
	x3: i32, y3: i32, colour: Color) {

	tri(
		d,
		x1 as f32, y1 as f32,
		x2 as f32, y2 as f32,
		x3 as f32, y3 as f32, colour);
}


pub fn main() {
	println!("Starting raylib-rs...");
	io::stdout().flush().expect("Unable to flush!");

	let (mut rl, thread) = raylib::init().build();

	rl.set_window_size(WW, WH);

	// let cornflower_blue = Color::new(0x64, 0x95, 0xed, 0xff);
	let raylib_icon = Image::load_image("assets/images/window_icon.png")
		.expect("Unable to load window_icon.png!");
	rl.set_window_icon(&raylib_icon);
	rl.set_window_title(&thread, "#genuary24 - by Hevanafa");
	
	rl.set_target_fps(60);

	let mut t = 0_i32;

	while !rl.window_should_close() {
		// update
		t += 1;

		// draw
		let mut d = rl.begin_drawing(&thread);

		d.clear_background(Color::RAYWHITE);
		// d.draw_texture(&raylib_logo, 20, 60, Color::RAYWHITE);

		for b in 0..WH / 20 {
			for a in 0..WW / 20 {
				let (r, g, blue) = hsv2rgb(
					a as f32 / 10.0 + t as f32 / 100.0, 0.3, 1.0);
					
				let colour = Color::new(r as u8, g as u8, blue as u8, 0xff);

				tri_i(&mut d,
					a * 40 + 20, b * 40,
					a * 40, b * 40 + 40,
					a * 40 + 40, b * 40 + 40, colour);
			}
		}
	}
}