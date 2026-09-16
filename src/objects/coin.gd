extends AnimatedSprite2D

# MileTux

# Coin - A simple coin that increases the coin amount in the HUD on screen

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
	play("default")
	$TuxDetector.connect("body_entered", _on_something_detected)
	$Sound.connect("finished", _on_sound_finished)

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		$TuxDetector.set_deferred("monitoring", false)
		$Animation.play("collect")
		$Sound.play()
		Global.coins += 1
		Signals.coin_collected.emit()

func _on_sound_finished():
	queue_free()

func set_from_block():
	if Global.paused:
		return
	
	$TuxDetector.set_deferred("monitoring", false)
	$Animation.play("collect")
	Global.coins += 1
	Signals.coin_collected.emit()
