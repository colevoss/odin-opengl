package main

import "vendor:glfw"

Context :: struct {
	window: Window,
	input:  Input,
	time:   f32,
	delta:  f32,
}

Input_Mouse :: struct {
	pos:   [2]f32,
	delta: [2]f32,
}

Input :: struct {
	mouse: Input_Mouse,
}

context_init :: proc(ctx: ^Context, window: Window) {
	ctx.window = window
	ctx.input.mouse.pos.x = f32(window.width) / 2
	ctx.input.mouse.pos.y = f32(window.height) / 2
}

context_update :: proc(ctx: ^Context) {
	time := f32(glfw.GetTime())
	ctx.delta = time - ctx.time
	ctx.time = time

	input_update(ctx)
}

input_update :: proc "contextless" (ctx: ^Context) {
	x, y := glfw.GetCursorPos(ctx.window.handle)
	mouse := Vec2{f32(x), f32(y)}
	input_update_mouse(&ctx.input, mouse)
}

input_update_mouse :: proc "contextless" (i: ^Input, new_mouse: [2]f32) {
	delta: Vec2
	delta.x = new_mouse.x - i.mouse.pos.x
	// reversed since y-coordinates range from bottom to top
	delta.y = i.mouse.pos.y - new_mouse.y

	i.mouse = Input_Mouse {
		delta = delta,
		pos   = new_mouse,
	}
}
