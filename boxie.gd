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
#3. This notice may not be removed or altered from any source distribution.

extends KinematicBody

var follow = 0
var drag = false
var move_drag = false
var velocity = 0
onready var cam = get_parent().get_node("Camera")
onready var size = cam.get_viewport().get_rect().size
onready var center = Vector2(size.x/2.0, size.y/2.0)

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if drag and event.type == InputEvent.MOUSE_MOTION:
		move_drag = true

func _fixed_process(delta):
	if not drag:
		velocity += delta*-9.8
		move(Vector3(0, velocity, 0)*delta)
		if is_colliding():
			velocity = 0

	elif move_drag:
		move_drag = false

		var cam_pos = cam.get_translation()
		var max_dist = (cam_pos-get_translation()).length()
		var rc = cam.get_node("collision-ray")
		rc.add_exception(get_node("."))
		rc.set_cast_to(Vector3(0,0,-1 * max_dist))

		var new_dist = 0.0
		if rc.is_colliding():
			new_dist = (cam_pos-rc.get_collision_point()).length()
			set_scale((new_dist/max_dist)*get_scale())
		else:
			 new_dist = max_dist

		var pos = cam.get_translation() + new_dist*cam.project_ray_normal(center)
		set_translation(pos)
