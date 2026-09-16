extends CanvasLayer

# MileTux

# Fade - Fades in/out

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

## Emitted when any function in fade.gd is done except _enter_tree().
signal finished

# Sets visible to false. Simple!
func _enter_tree() -> void:
	$Animation.play("invisible")
	visible = false

## Fades in. Speed is how fast / slow it is to fade in.
## [br]
## Also emits finished.
func fade_in(speed:float):
	visible = true
	$Animation.play("fade_in", -1, speed)
	await $Animation.animation_finished
	finished.emit()

## Fades out. Speed is how fast / slow it is to fade out.
## [br]
## Also emits finished.
func fade_out(speed:float):
	visible = true
	$Animation.play("fade_out", -1, speed)
	await $Animation.animation_finished
	finished.emit()

## Resets to black.
## [br]
## Also emits finished.
func reset_to_black():
	visible = true
	$Animation.play("RESET")
	await $Animation.animation_finished # just to be safe
	finished.emit()

## Turns invisible. Every other function (except _enter_tree()) makes it visible, including reset_to_black.
## [br]
## Also emits finished.
func turn_invisible():
	visible = false
	$Animation.play("invisible")
	await $Animation.animation_finished
	finished.emit()
