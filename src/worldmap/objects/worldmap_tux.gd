extends CharacterBody2D

# MileTux

# Worldmap Tux - The movable player character on the worldmap

# Copyright (C) 2004 Ingo Ruhnke <grumbel@gmail.com>
# Copyright (C) 2006 Christoph Sommer <christoph.sommer@2006.expires.deltadevelopment.de>
# Copyright (C) 2026 Sophie Ball <sophieballvaesea@proton.me>
# Copyright (C) 2026 AnatolyStev

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

# This code is mostly from the (currently-unreleased) game I'm working on named Tux Mystery.

@export var speed = 192

var current_state:TuxManager.TuxStates

func _ready() -> void:
	add_to_group("TuxWorldmap")
	reload_player()

func _physics_process(_delta: float) -> void:
	if Global.paused:
		return
	
	if position.x < 0:
		position.x = 0
	
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	velocity = direction * speed
	
	if not velocity == Vector2.ZERO:
		velocity = velocity.normalized() * speed
	
	if not velocity == Vector2.ZERO:
		$Image.play("walk")
		$FireImage.play("walk")
	else:
		$Image.play("stand")
		$FireImage.play("stand")
	
	move_and_slide()

func reload_player():
	if current_state == TuxManager.TuxStates.FIRE:
		$Image.visible = false
		$FireImage.visible = true
	else:
		$Image.visible = true
		$FireImage.visible = false
