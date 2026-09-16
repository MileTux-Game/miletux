extends CanvasLayer

# MileTux

# Worldmap HUD - The HUD displayed in the worldmap scenes.
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

func _ready() -> void:
	update_text()
	Signals.update_level_text.connect(update_text)

func update_text():
	$Coins.text = "Coins: " + str(Global.coins)
	$Level.text = Global.dot_level_name
