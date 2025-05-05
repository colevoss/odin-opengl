package main

import "core:fmt"
import "core:math"
import glm "core:math/linalg"
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

	tex1: Texture
	texture_init(&tex1)
	texture_load(&tex1, "./textures/wall.jpg")

	tex2: Texture
	texture_init(&tex2)
	texture_load(&tex2, "./textures/wood.jpg")

	clear_color := Vec4{0.5, 0.0, 1.0, 1.0}

	cubePositions := []glm.Vector3f32 {
		{0.0, 0.0, 0.0},
		{2.0, 5.0, -15.0},
		{-1.5, -2.2, -2.5},
		{-3.8, -2.0, -12.3},
		{2.4, -0.4, -3.5},
		{-1.7, 3.0, -7.5},
		{1.3, -2.0, -2.5},
		{1.5, 2.0, -2.5},
		{1.5, 0.2, -1.5},
		{-1.3, 1.0, -1.5},
	}


	vbo: VBO
	vbo.vertices = cube
	//vbo.vertices = vertices
	vbo_init(&vbo)

	ebo: EBO
	ebo.indices = []u32{0, 1, 3, 1, 2, 3}
	//ebo.indices = []u32{0, 1, 2}
	ebo_init(&ebo)

	vao: VAO
	vao.vbo = &vbo
	vao.ebo = &ebo
	vao.attributes = {
		{index = 0, size = 3, type = .Float, normalized = false, stride = 5, offset = 0}, // position
		{index = 1, size = 2, type = .Float, normalized = false, stride = 5, offset = 3}, // color
		//{index = 1, size = 3, type = .Float, normalized = false, stride = 8, offset = 3}, // color
		//{index = 2, size = 2, type = .Float, normalized = false, stride = 5, offset = 3}, // color
	}
	vao_init(&vao)

	shader: Shader

	if !shader_init_from_file(&shader, "./shaders/basic.vs", "./shaders/basic.fs") {
		fmt.eprintln("error initializing shader")
		return
	}

	//model = glm.matrix4_rotate_f32(glm.to_radians(f32(-55)), Vec3{1, 0, 0}) * model

	view := glm.MATRIX4F32_IDENTITY
	// note that we translate the scene inverse to the direction we want to move
	view = glm.matrix4_translate_f32(glm.Vector3f32{0, 0, -3})

	projection := glm.matrix4_perspective_f32(glm.to_radians(f32(45)), 800 / 600, 0.1, 1000)

	gl.Enable(gl.DEPTH_TEST)

	// polygon mode
	// gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)
	for window_run(&window) {
		// INPUT
		if glfw.GetKey(window.handle, glfw.KEY_ESCAPE) == glfw.PRESS {
			glfw.SetWindowShouldClose(window.handle, true)
		}

		time := glfw.GetTime()


		// Draw
		window_clear(clear_color)

		shader_use(&shader)

		//shader_set(&shader, "texture1", 0)
		//shader_set(&shader, "texture2", 1)
		shader_set(&shader, "view", &view)
		shader_set(&shader, "projection", &projection)


		// shader_set_1_float(&shader, "myMix", f32(mix))

		gl.ActiveTexture(gl.TEXTURE0)
		texture_bind_2d(&tex1)

		gl.ActiveTexture(gl.TEXTURE1)
		texture_bind_2d(&tex2)

		vao_bind(&vao)


		for c, i in cubePositions {
			model := glm.MATRIX4F32_IDENTITY
			model =
				glm.matrix4_rotate_f32(glm.to_radians(f32(time * 10)), Vec3{1, 0.3, 0.5}) * model
			model = glm.matrix4_translate_f32(c) * model
			shader_set(&shader, "model", &model)
			gl.DrawArrays(gl.TRIANGLES, 0, 36)
		}

		//gl.DrawElements(gl.TRIANGLES, 36, gl.UNSIGNED_INT, nil)
		//gl.DrawArrays(gl.TRIANGLES, 0, 36)

		// PREPARE NEXT FRAME
		glfw.PollEvents()
		glfw.SwapBuffers(window.handle)
	}
}
