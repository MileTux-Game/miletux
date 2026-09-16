extends AnimatedSprite2D

# MileTux

# Checkpoint - Saves Tux's progress in a level
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)
	if not Global.checkpoint_reached:
		play("normal")
	else:
		play("ring")

func _on_something_detected(body):
	if body.is_in_group("Player") and not Global.checkpoint_reached:
		print("Checkpoint reached!")
		play("ring")
		Global.checkpoint_reached = true
		Global.checkpoint_position = position
