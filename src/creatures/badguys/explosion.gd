extends AnimatedSprite2D

# MileTux

# Explosion - An object that appears when something explodes.
# Copyright (C) 2007 Christoph Sommer <christoph.sommer@2007.expires.deltadevelopment.de>
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
	print("Explosion!!!!!")
	$Detector.connect("body_entered", _on_something_detected)
	$Sound.connect("finished", _on_sound_finished)
	play("default")
	$Sound.play()
	$Particles.emitting = true
	$Particles.connect("finished", _on_particles_finished)

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player"):
		if not Global.tux_star_invincible:
			body.damage()
	if body.is_in_group("Badguy"):
		if body is Iceblock: # TODO: add iceblock variable to badguy instead of doing this weird thing
			body.death_fall(true)
		else:
			body.death_fall(false)

func _on_sound_finished():
	if Global.paused:
		return
	
	print("Explosion gone?????")
	self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Detector.set_deferred("monitoring", false)
	$Detector.set_deferred("monitorable", false)

func _on_particles_finished():
	if Global.paused:
		return
	
	print("Explosion actually gone!!!!!")
	queue_free()
