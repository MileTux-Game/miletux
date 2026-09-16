extends CharacterBody2D

# MileTux

# Star - A power-up that temporarily turns Tux invincible

# Copyright (C) 2006 Matthias Braun <matze@braunis.de>
# Copyright (C) 2026 Sophie Ball <sophieballvaesea@proton.me>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the license or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should've received a copy of the GNU General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

var direction = 1
var speed = 150
var initial_jump = 400
var jump_height = 300
var was_on_wall = false

func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity = Vector2.ZERO
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		velocity.y = -jump_height
	
	velocity.x = direction * speed
	
	if is_on_wall() and not was_on_wall:
		flip_direction()
	
	was_on_wall = is_on_wall()
	
	move_and_slide()

func flip_direction():
	direction = -direction

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		body.get_star()
		queue_free()

func spawn_from_block(go_to_direction:int):
	if Global.paused:
		return
	
	velocity.y = -initial_jump
	direction = go_to_direction
