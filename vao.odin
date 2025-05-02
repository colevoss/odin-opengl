package main

import gl "vendor:OpenGL"

VAO :: struct {
	id:         u32,
	vbo:        ^VBO,
	ebo:        ^EBO,
	attributes: []VertexAttribute,
}

VertexAttribute_Type :: enum {
	Float = gl.FLOAT,
}


VertexAttribute :: struct {
	index:      u32,
	size:       i32,
	type:       VertexAttribute_Type,
	normalized: bool,
	stride:     i32,
	offset:     i32,
}

vao_init :: proc(vao: ^VAO) {
	gl.GenVertexArrays(1, &vao.id)

	// bind VAO
	vao_bind(vao)

	// Buffer VBO
	vbo_bind(vao.vbo)
	vbo_buffer_data(vao.vbo)

	ebo_bind(vao.ebo)
	ebo_buffer_data(vao.ebo)

	for attrib in vao.attributes {
		vertex_attribute_init(attrib)
	}
}

vao_bind :: proc(vao: ^VAO) {
	gl.BindVertexArray(vao.id)
}

vertex_attribute_init :: proc(v: VertexAttribute) {
	gl.VertexAttribPointer(
		v.index,
		v.size,
		u32(v.type),
		v.normalized,
		v.stride * vertex_attribute_type_size(v.type),
		uintptr(v.offset * size_of(f32)),
	)

	gl.EnableVertexAttribArray(v.index)
}

vertex_attribute_type_size :: proc(type: VertexAttribute_Type) -> i32 {
	switch type {
	case .Float:
		return size_of(f32)
	}

	return 0
}
