extends Node2D

# MileTux

# Main Menu - Title screen with various options to choose from
# Copyright (C) 2004 Tobias Glaesser <tobi.web@gmx.de>
# Copyright (C) 2006 Matthias Braun <matze@braunis.de>
# Copyright (C) 2023 Vankata453
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

@export_file("*.ogg") var music = "res://data/music/theme.ogg"
@export_file("*.tscn") var intro_scene = "res://src/menu/intro.tscn"
@export_file("*.tscn") var credits_scene = "res://src/menu/credits.tscn"

func _ready() -> void:
	Music.stream = load(music)
	Music.play()
	$Panel/VBoxContainer/Play.connect("pressed", _on_play_pressed)
	$Panel/VBoxContainer/BonusLevels.connect("pressed", _on_bonus_pressed)
	$Panel/VBoxContainer/Options.connect("pressed", _on_options_pressed)
	$Panel/VBoxContainer/Credits.connect("pressed", _on_credits_pressed)
	$Panel/VBoxContainer/Exit.connect("pressed", _on_exit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file(intro_scene)

func _on_bonus_pressed():
	pass

func _on_options_pressed():
	pass

func _on_credits_pressed():
	get_tree().change_scene_to_file(credits_scene)

func _on_exit_pressed():
	get_tree().quit(0)
