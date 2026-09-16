extends StaticBody2D

# MileTux

# Rock - A rock on the worldmap that is only removed when the player has
# beaten all the levels in the rock's section

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

## This should be one or more than 1.[br]
## Setting to 0 hasn't been tested.
@export var rock_section = 1

var gone = false

func _ready() -> void:
	add_to_group("Rock")

func remove_rock():
	if not gone:
		gone = true
		queue_free()
