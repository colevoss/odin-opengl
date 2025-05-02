package main

import gl "vendor:OpenGL"

EBO :: struct {
	id:      u32,
	indices: []u32,
}

ebo_init :: proc(ebo: ^EBO) {
	gl.GenBuffers(1, &ebo.id)
}

ebo_bind :: proc(ebo: ^EBO) {
	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo.id)
}

// Sends indices data to GPU. Binds the EBO
ebo_buffer_data :: proc(ebo: ^EBO) {
	ebo_bind(ebo)

	gl.BufferData(
		gl.ELEMENT_ARRAY_BUFFER,
		len(ebo.indices) * size_of(ebo.indices[0]),
		raw_data(ebo.indices),
		gl.STATIC_DRAW,
	)
}
