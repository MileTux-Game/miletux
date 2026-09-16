extends Node2D

# MileTux

# Options Menu - Allows the player to set various things on and off (doesn't work yet)
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

@export_file("*.ogg") var music = "res://data/music/options.ogg"
@export_file("*.tscn") var main_menu = "res://src/menu/main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.stream = load(music)
	Music.play()
	$Panel/VBoxContainer/Particles.connect("toggled", _on_particles_toggled)
	$Panel/VBoxContainer/LevelHUD.connect("toggled", _on_level_hud_toggled)
	$Panel/VBoxContainer/DebugMode.connect("toggled", _on_debug_toggled)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_exit"):
		get_tree().change_scene_to_file(main_menu)

func _on_particles_toggled(toggled_on:bool):
	if toggled_on:
		Global.particles = true
	else:
		Global.particles = false

func _on_level_hud_toggled(toggled_on:bool):
	if toggled_on:
		Global.level_hud = true
	else:
		Global.level_hud = false

func _on_debug_toggled(toggled_on:bool):
	if toggled_on:
		Global.debug = true
	else:
		Global.debug = false
