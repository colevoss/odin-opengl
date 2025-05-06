package main

import "core:fmt"
import "core:math"
import glm "core:math/linalg"
import "core:os"
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

	ctx: Context
	context_init(&ctx, window)
	//ctx.window = window

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
	ebo_init(&ebo)

	vao: VAO
	vao.vbo = &vbo
	vao.ebo = &ebo
	vao.attributes = {
		{index = 0, size = 3, type = .Float, normalized = false, stride = 5, offset = 0}, // position
		{index = 1, size = 2, type = .Float, normalized = false, stride = 5, offset = 3}, // tex
	}
	vao_init(&vao)

	shader: Shader

	if !shader_init_from_file(&shader, "./shaders/basic.vs", "./shaders/basic.fs") {
		fmt.eprintln("error initializing shader")
		return
	}

	view := glm.MATRIX4F32_IDENTITY
	projection := glm.matrix4_perspective_f32(glm.to_radians(f32(45)), 800 / 600, 0.1, 1000)

	gl.Enable(gl.DEPTH_TEST)

	camera: Camera
	camera.pos = Vec3{0, 0, 3}
	camera.sensitivity = 0.3
	camera.pitch = 300 * 0.3
	camera.yaw = 400 * 0.3
	camera_init(&camera)
	//camera_look_at(&camera, Vec3{0, 0, 0})

	// polygon mode
	// gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)
	for window_run(&window) {
		context_update(&ctx)
		camera_update(&camera, ctx.input.mouse.delta)

		// INPUT
		if glfw.GetKey(window.handle, glfw.KEY_ESCAPE) == glfw.PRESS {
			glfw.SetWindowShouldClose(window.handle, true)
		}
		if glfw.GetKey(window.handle, glfw.KEY_W) == glfw.PRESS {
			camera.pos += ctx.delta * camera.front
		}
		if glfw.GetKey(window.handle, glfw.KEY_S) == glfw.PRESS {
			camera.pos -= ctx.delta * camera.front
		}
		if glfw.GetKey(window.handle, glfw.KEY_A) == glfw.PRESS {
			camera.pos -= glm.vector_normalize(glm.cross(camera.front, camera.up)) * ctx.delta
		}
		if glfw.GetKey(window.handle, glfw.KEY_D) == glfw.PRESS {
			camera.pos += glm.vector_normalize(glm.cross(camera.front, camera.up)) * ctx.delta
		}

		//camera.pos.y = 0

		view = camera_view(&camera)

		// Draw
		window_clear(clear_color)

		shader_use(&shader)

		shader_set(&shader, "view", &view)
		shader_set(&shader, "projection", &projection)

		gl.ActiveTexture(gl.TEXTURE0)
		texture_bind_2d(&tex1)

		gl.ActiveTexture(gl.TEXTURE1)
		texture_bind_2d(&tex2)

		vao_bind(&vao)

		for c, i in cubePositions {
			model := glm.MATRIX4F32_IDENTITY
			model = glm.matrix4_rotate_f32(glm.to_radians(ctx.time * 10), Vec3{1, 0, 0}) * model
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
