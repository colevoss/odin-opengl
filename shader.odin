package main

import gl "vendor:OpenGL"

Shader :: struct {
	program:  u32,
	uniforms: gl.Uniforms,
}

shader_init_from_string :: proc(shader: ^Shader, vs, fs: string) -> bool {
	program := gl.load_shaders_source(vs, fs) or_return
	uniforms := gl.get_uniforms_from_program(program)

	shader.program = program
	shader.uniforms = uniforms

	return true
}

shader_init_from_file :: proc(shader: ^Shader, v_path, f_path: string) -> bool {
	program := gl.load_shaders_file(v_path, f_path) or_return
	uniforms := gl.get_uniforms_from_program(program)

	shader.program = program
	shader.uniforms = uniforms

	return true
}

shader_use :: proc(shader: ^Shader) {
	gl.UseProgram(shader.program)
}

shader_delete_program :: proc(shader: ^Shader) {
	gl.DeleteProgram(shader.program)
}

shader_set :: proc {
	shader_set_bool,
	shader_set_1_int,
	shader_set_2_int,
	shader_set_3_int,
	shader_set_1_float,
	shader_set_2_float,
	shader_set_3_float,
	shader_set_vec2,
	shader_set_vec3,
	shader_set_vec4,
	shader_set_mat_4x4f,
}

shader_set_bool :: proc "contextless" (shader: ^Shader, uniform: string, b: bool) {
	gl.Uniform1i(shader.uniforms[uniform].location, i32(b))
}

shader_set_1_int :: proc "contextless" (shader: ^Shader, uniform: string, i: int) {
	gl.Uniform1i(shader.uniforms[uniform].location, i32(i))
}

shader_set_2_int :: proc "contextless" (shader: ^Shader, uniform: string, i0, i1: int) {
	gl.Uniform2i(shader.uniforms[uniform].location, i32(i0), i32(i1))
}

shader_set_3_int :: proc "contextless" (shader: ^Shader, uniform: string, i0, i1, i3: int) {
	gl.Uniform3i(shader.uniforms[uniform].location, i32(i0), i32(i1), i32(i3))
}

shader_set_4_int :: proc "contextless" (shader: ^Shader, uniform: string, i0, i1, i3, i4: int) {
	gl.Uniform4i(shader.uniforms[uniform].location, i32(i0), i32(i1), i32(i3), i32(i4))
}

shader_set_1_float :: proc "contextless" (shader: ^Shader, uniform: string, i: f32) {
	gl.Uniform1f(shader.uniforms[uniform].location, i)
}

shader_set_2_float :: proc "contextless" (shader: ^Shader, uniform: string, i0, i1: f32) {
	gl.Uniform2f(shader.uniforms[uniform].location, i0, i1)
}

shader_set_3_float :: proc "contextless" (shader: ^Shader, uniform: string, i0, i1, i3: f32) {
	gl.Uniform3f(shader.uniforms[uniform].location, i0, i1, i3)
}

shader_set_4_float :: proc "contextless" (shader: ^Shader, uniform: string, i0, i1, i3, i4: f32) {
	gl.Uniform4f(shader.uniforms[uniform].location, i0, i1, i3, i4)
}

shader_set_vec2 :: proc "contextless" (shader: ^Shader, uniform: string, vec: ^[2]f32) {
	gl.Uniform2fv(shader.uniforms[uniform].location, 1, raw_data(vec))
}

shader_set_vec3 :: proc "contextless" (shader: ^Shader, uniform: string, vec: ^[3]f32) {
	gl.Uniform3fv(shader.uniforms[uniform].location, 1, raw_data(vec))
}

shader_set_vec4 :: proc "contextless" (shader: ^Shader, uniform: string, vec: ^[4]f32) {
	gl.Uniform4fv(shader.uniforms[uniform].location, 1, raw_data(vec))
}

shader_set_mat_4x4f :: proc "contextless" (s: ^Shader, uniform: string, mat: ^matrix[4, 4]f32) {
	gl.UniformMatrix4fv(s.uniforms[uniform].location, 1, gl.FALSE, raw_data(mat))
}
