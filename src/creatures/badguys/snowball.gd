extends Badguy
class_name Snowball

# MileTux

# Snowball - A badguy
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
	$TuxDetector.connect("area_entered", _on_tux_detector_area_entered)
	$TuxDetector.connect("body_entered", _on_tux_detector_body_entered)
	$Image.play("walk")
	super()

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity.x = 0
		velocity.y = 0
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if current_state == BadguyStates.ALIVE:
		velocity.x = direction * speed
	else:
		velocity.x = 0
	
	if is_on_wall():
		if velocity.x * get_wall_normal().x < 0:
			flip_direction()
	
	if direction == 1:
		$Image.flip_h = true
	else:
		$Image.flip_h = false
	
	move_and_slide()

func flip_direction():
	direction = -direction

func _on_tux_detector_area_entered(area):
	if Global.paused:
		return
	
	if area.is_in_group("Stomp"):
		if current_state == BadguyStates.DEAD:
			return
		
		if get_tux_stomp(area.get_parent(), true):
			if not Global.tux_star_invincible:
				area.get_parent().stomp_bounce()
				death_squish()
			else:
				death_fall(false)

func _on_tux_detector_body_entered(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not get_tux_stomp(body, false):
		held_badguy_check(true, body)
	if body.is_in_group("Badguy"):
		if body == self:
			return
			
		if body.kill_other_enemies:
			death_fall(false)
		if body.kill_self_on_touching_enemy:
			body.death_fall(true)
		if not body.kill_other_enemies or not body.kill_self_on_touching_enemy:
			flip_direction()
