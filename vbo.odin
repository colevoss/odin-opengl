package main

import gl "vendor:OpenGL"

// Vertext Buffer Object (VBO) is used to store a large number
// of vertices in the GPU's memory
VBO :: struct {
	id:       u32,
	vertices: []f32,
}

// Initalizes a Vertex Buffer Object by generating the buffer in OpenGL
// and assigning the generated id to the vbo
vbo_init :: proc(vbo: ^VBO) {
	gl.GenBuffers(1, &vbo.id)
}

// The buffer type of a VBO is ARRAY_BUFFER
// Sets the currently bound VBO to `v`
vbo_bind :: proc(vbo: ^VBO) {
	gl.BindBuffer(gl.ARRAY_BUFFER, vbo.id)
}

// Sends the vertex data of the VBO to the GPU (binds the VBO)
vbo_buffer_data :: proc(vbo: ^VBO) {
	vbo_bind(vbo)

	gl.BufferData(
		gl.ARRAY_BUFFER,
		len(vbo.vertices) * size_of(vbo.vertices[0]),
		raw_data(vbo.vertices),
		gl.STATIC_DRAW,
	)
}
