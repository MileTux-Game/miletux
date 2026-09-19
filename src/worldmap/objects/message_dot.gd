extends Sprite2D

# MileTux

# Message Dot - When Tux is over it, a message appears.

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

@export var message = ""
@export var show_in_game = false

func _ready() -> void:
	if show_in_game:
		visible = true
	else:
		visible = false
	
	$Detector.connect("body_entered", _on_something_detected)
	$Detector.connect("body_exited", _on_something_exited)

func _on_something_detected(body):
	if body.is_in_group("TuxWorldmap"):
		Global.dot_level_name = message
		Signals.update_level_text.emit()

func _on_something_exited(body):
	if body.is_in_group("TuxWorldmap"):
		Global.dot_level_name = ""
		Signals.update_level_text.emit()
