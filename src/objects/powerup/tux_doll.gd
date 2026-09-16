extends CharacterBody2D

# MileTux

# Tux Doll - A power-up that gives the player 100 coins.

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

@export var floating = false
@export var jump_height = 400
@export var speed = 100
var direction = -1

func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)
	$Life.connect("finished", _on_sound_finished)
	
	if not floating:
		velocity.y = -jump_height

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity = Vector2.ZERO
		return
	if not floating:
		velocity.x = direction * speed
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		Global.coins += 100
		Signals.coin_collected.emit()
		$Image.visible = false
		$Life.play()
	
func _on_sound_finished():
	if Global.paused: # This might cause a bug? Let's see later...
		return
	
	queue_free()
