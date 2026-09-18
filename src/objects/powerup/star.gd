extends CharacterBody2D

# MileTux

# Star - A power-up that temporarily turns Tux invincible
#
# Copyright (C) 2006 Matthias Braun <matze@braunis.de>
# Copyright (C) 2026 Sophie Ball <sophieballvaesea@proton.me>
#
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

# Movement
var direction = 1
var speed = 150
var initial_jump = 400
var jump_height = 300
var initial_speed = 96

# Other Stuff
var just_appeared = true

# Connect body_entered so Tux can be detected
func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)

func _physics_process(delta: float) -> void:
	if Global.paused: # Star shouldn't move if the game is "paused"!
		velocity = Vector2.ZERO
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# If not just appeared and is now on floor, jump with the normal jump height!
	if is_on_floor():
		if not just_appeared:
			velocity.y = -jump_height
		
		just_appeared = false
	
	if just_appeared:
		velocity.x = direction * initial_speed
	else:
		velocity.x = direction * speed
	
	# Extra Safety!!!
	if is_on_ceiling():
		just_appeared = false
	
	if is_on_wall():
		if velocity.x * get_wall_normal().x < 0:
			flip_direction()
	
	# Why, Godot?
	move_and_slide()

# Flip direction
func flip_direction():
	direction = -direction

# If something is detected, check whether it's an alive Tux and give the star powers to Tux if he is. Also, this
# (intentionally) makes the star stop existing for obvious reasons.
func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		body.get_star()
		queue_free()

# Spawn the star from a block with an initial jump height to make it accurate!
func spawn_from_block(go_to_direction:int):
	if Global.paused:
		return
	
	velocity.y = -initial_jump
	direction = go_to_direction
	velocity.x = direction * initial_speed
