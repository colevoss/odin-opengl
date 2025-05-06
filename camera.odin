package main

import "core:fmt"
import "core:math"
import glm "core:math/linalg"

WorldUp := [3]f32{0, 1, 0}

Camera :: struct {
	pos:         [3]f32,
	front:       [3]f32,
	direction:   [3]f32,
	pitch:       f32,
	yaw:         f32,
	sensitivity: f32,
	//
	target:      [3]f32,
	right:       [3]f32,
	up:          [3]f32,
}

camera_init :: proc(c: ^Camera) {
	c.up = WorldUp
	c.front = Vec3{0, 0, -1}
	camera_update(c, Vec2{0, 0})
}

//camera_look_at :: proc(c: ^Camera, target: [3]f32) {
//	c.front = glm.normalize(c.pos - target)
//}

camera_view :: proc(c: ^Camera) -> matrix[4, 4]f32 {
	return glm.matrix4_look_at_f32(c.pos, c.pos + c.front, c.up)
}

camera_update :: proc(c: ^Camera, move: Vec2) {
	c.pitch = clamp(c.pitch + (move.y * c.sensitivity), -89, 89)
	c.yaw += move.x * c.sensitivity

	front: Vec3
	front.x = math.cos(math.to_radians(c.yaw)) * math.cos(math.to_radians(c.pitch))
	front.y = math.sin(math.to_radians(c.pitch))
	front.z = math.sin(math.to_radians(c.yaw)) * math.cos(math.to_radians(c.pitch))

	c.front = glm.normalize(front)
	c.right = glm.normalize(glm.cross(c.front, WorldUp))
	c.up = glm.normalize(glm.cross(c.right, c.front))
}
