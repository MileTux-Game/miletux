extends Node2D

# MileTux

# Brick Particles - Spawned when a brick is broken
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

var snow = false
var snow_brick_path = "res://data/images/objects/brick/brick1.png"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if snow:
		$One.texture = load(snow_brick_path)
		$Two.texture = load(snow_brick_path)
		$Three.texture = load(snow_brick_path)
		$Four.texture = load(snow_brick_path)
	$DisappearTimer.connect("timeout", _on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.paused:
		return
	
	$One.position += Vector2(-100, -400) * delta
	$Two.position += Vector2(100, -400) * delta
	$Three.position += Vector2(-150, -300) * delta
	$Four.position += Vector2(150, -300) * delta

func _on_timer_timeout():
	if Global.paused:
		return
	
	queue_free()
