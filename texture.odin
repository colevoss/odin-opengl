package main

import "core:strings"
import gl "vendor:OpenGL"
import "vendor:stb/image"

Texture :: struct {
	id:            u32,
	file_channels: i32,
	width:         i32,
	height:        i32,
}

texture_init :: proc(texture: ^Texture) {
	gl.GenTextures(1, &texture.id)
}

texture_bind_2d :: proc(texture: ^Texture) {
	gl.BindTexture(gl.TEXTURE_2D, texture.id)
}

texture_load :: proc(texture: ^Texture, path: string) {
	data := image.load(
		strings.clone_to_cstring(path),
		&texture.width,
		&texture.height,
		&texture.file_channels,
		0,
	)

	texture_bind_2d(texture)
	texture_settings()

	gl.TexImage2D(
		gl.TEXTURE_2D,
		0, // mipmap level (0 for now)
		gl.RGB, // what to store the data as
		texture.width,
		texture.height,
		0, // always set to 0 (legacy)
		gl.RGB, // color data format of image
		gl.UNSIGNED_BYTE, // data format of image
		data,
	)

	gl.GenerateMipmap(gl.TEXTURE_2D)

	image.image_free(data)
}

texture_settings :: proc() {
	// wrapping
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.MIRRORED_REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.MIRRORED_REPEAT)

	// filtering
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)

	// mipmap filtering
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
}
