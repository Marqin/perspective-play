#Copyright (c) 2016 Hubert Jarosz
#
#This software is provided 'as-is', without any express or implied
#warranty. In no event will the authors be held liable for any damages
#arising from the use of this software.
#
#Permission is granted to anyone to use this software for any purpose,
#including commercial applications, and to alter it and redistribute it
#freely, subject to the following restrictions:
#
#1. The origin of this software must not be misrepresented; you must not
#   claim that you wrote the original software. If you use this software
#   in a product, an acknowledgement in the product documentation would be
#   appreciated but is not required.
#2. Altered source versions must be plainly marked as such, and must not be
#   misrepresented as being the original software.
#3. This notice may not be removed or altered from any source distribution

extends Camera

var yaw = 0
var pitch = 0
var view_sensitivity = 0.5
var test_aim = false
onready var box = get_parent().get_node("draggable-box")
onready var aimer = get_node("aim-ray")

func _ready():
	var screen_size = get_viewport().get_rect().size
	get_node("aim").set_pos(Vector2(screen_size.x/2.0, screen_size.y/2.0))
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		yaw = fmod(yaw - event.relative_x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 85), -85)
		set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0))
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		if box.drag:
			box.drag = false
		else:
			test_aim = true

func _fixed_process(delta):
	if test_aim:
		test_aim = false
		aimer.set_cast_to(Vector3(0,0,-1000))
		if aimer.is_colliding() and (aimer.get_collider() == box):
			box.drag = true
