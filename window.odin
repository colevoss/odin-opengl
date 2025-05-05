package main

import "core:fmt"
import "core:strings"
import gl "vendor:OpenGL"
import "vendor:glfw"

// @note You might need to lower this to 3.3 depending on how old your graphics card is.
GL_MAJOR_VERSION :: 4
//GL_MINOR_VERSION :: 5
GL_MINOR_VERSION :: 1

Window :: struct {
	width:  int,
	height: int,
	title:  string,
	handle: glfw.WindowHandle,
}

window_init :: proc(w: ^Window) -> bool {
	if !bool(glfw.Init()) {
		err, err_code := glfw.GetError()
		fmt.eprintf("GLFW failed to load: (%d) %s", err_code, err)
		return false
	}

	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, gl.TRUE)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)

	window_handle := glfw.CreateWindow(
		i32(w.width),
		i32(w.height),
		strings.clone_to_cstring(w.title),
		nil,
		nil,
	)

	if window_handle == nil {
		err, err_code := glfw.GetError()
		fmt.eprintf("GLFW failed to create window: (%d) %s", err_code, err)
		return false
	}

	w.handle = window_handle

	// Load OpenGL context or the "state" of OpenGL.
	glfw.MakeContextCurrent(w.handle)
	// Load OpenGL function pointers with the specficed OpenGL major and minor version.
	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

	return true
}

window_run :: proc(w: ^Window) -> bool {
	return !bool(glfw.WindowShouldClose(w.handle))
}

window_destory :: proc(w: ^Window) {
	glfw.DestroyWindow(w.handle)
	glfw.Terminate()
}

window_clear :: proc(color: Vec4) {
	gl.ClearColor(color.r, color.g, color.b, color.a)
	gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
}
