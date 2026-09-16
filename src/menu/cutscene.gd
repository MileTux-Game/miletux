extends Node2D

# MileTux

# Cutscene - A scene that usually has a textscroll as a child node.

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

@export var intro = false
@export_file("*.ogg") var music = "res://data/music/credits.ogg"

func _ready() -> void:
	if not intro:
		Music.stream = load(music)
		Music.play()
