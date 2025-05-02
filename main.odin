package main

import "core:fmt"
import "core:math"
import gl "vendor:OpenGL"
import "vendor:glfw"

Vec2 :: [2]f32
Vec3 :: [3]f32
Vec4 :: [4]f32

main :: proc() {
	window := Window {
		width  = 800,
		height = 600,
		title  = "BALLS",
	}

	if !window_init(&window) {
		return
	}

	defer window_destory(&window)

	clear_color := Vec4{0.5, 0.0, 1.0, 1.0}
	
  // odinfmt: disable
  vertices := []f32{
    // 0.5,  0.5, 0.0,  // top right
    // 0.5, -0.5, 0.0,  // bottom right
    //-0.5, -0.5, 0.0,  // bottom let
    //-0.5,  0.5, 0.0   // top let }



    // positions         // colors
     0.5, -0.5, 0.0,  1.0, 0.0, 0.0,   // bottom right
    -0.5, -0.5, 0.0,  0.0, 1.0, 0.0,   // bottom let
     .0,  0.5, 0.0,   0.0, 0.0, 1.0    // top
  }
  // odinfmt: enable

	vbo: VBO
	vbo.vertices = vertices
	vbo_init(&vbo)

	ebo: EBO
	//ebo.indices = []u32{0, 1, 3, 1, 2, 3}
	ebo.indices = []u32{0, 1, 2}
	ebo_init(&ebo)

	vao: VAO
	vao.vbo = &vbo
	vao.ebo = &ebo
	vao.attributes = {
		{index = 0, size = 3, type = .Float, normalized = false, stride = 6, offset = 0}, // position
		{index = 1, size = 3, type = .Float, normalized = false, stride = 6, offset = 3}, // color
	}
	vao_init(&vao)
	//vao_bind(&vao)

	shader: Shader

	if !shader_init_from_file(&shader, "./shaders/basic.vs", "./shaders/basic.fs") {
		fmt.eprintln("error initializing shader")
		return
	}

	// polygon mode
	// gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)

	for window_run(&window) {
		// INPUT
		if glfw.GetKey(window.handle, glfw.KEY_ESCAPE) == glfw.PRESS {
			glfw.SetWindowShouldClose(window.handle, true)
		}

		time := glfw.GetTime()
		green := (math.sin(time) / 2.0) + 0.5

		// Draw
		window_clear(clear_color)

		shader_use(&shader)
		shader_set(&shader, "ourColor", Vec4{0.4, f32(green), 0.0, 1.0})

		vao_bind(&vao)
		gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, nil)

		// PREPARE NEXT FRAME
		glfw.PollEvents()
		glfw.SwapBuffers(window.handle)
	}
}
