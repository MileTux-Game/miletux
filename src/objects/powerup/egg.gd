extends CharacterBody2D

# MileTux

# Egg - A power-up that turns Tux into Big Tux

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

var from_block = false
var direction = 1
var speed = 100
var was_on_wall = false

@export var affected_by_gravity = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)

func spawn_from_block(go_to_direction:int):
	if Global.paused:
		return
	
	$Collision.set_deferred("disabled", true)
	affected_by_gravity = false
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - 32), 0.8)
	await tween.finished
	direction = go_to_direction
	$Collision.set_deferred("disabled", false)
	affected_by_gravity = true

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity = Vector2.ZERO
		return
	
	if not is_on_floor() and affected_by_gravity:
		velocity += get_gravity() * delta
	
	if affected_by_gravity:
		velocity.x = direction * speed
	
	if is_on_wall() and not was_on_wall:
		flip_direction()
	
	move_and_slide()

func flip_direction():
	direction = -direction

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		body.grow("egg")
		queue_free()
