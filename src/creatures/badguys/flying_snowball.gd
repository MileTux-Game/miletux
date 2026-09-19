extends Badguy
class_name FlyingSnowball

# MileTux

# Flying Snowball - A basic badguy that moves up and down in the air.
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

var fly_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TuxDetector.connect("area_entered", _on_tux_detector_area_entered)
	$TuxDetector.connect("body_entered", _on_tux_detector_body_entered)
	$DirectionChange.connect("timeout", _on_dc_timeout)
	$Image.play("flying")
	velocity.y = -fly_speed
	$DirectionChange.start(0.5)
	super()

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity.x = 0
		velocity.y = 0
		return
	
	if not is_on_floor() and current_state == BadguyStates.DEAD:
		velocity += get_gravity() * delta
	
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
		
		if not Global.tux_star_invincible:
			if get_tux_stomp(area.get_parent(), true):
				bouncybouncebouncingsnowball = true
				area.get_parent().position.y -= 1 # i hate flying snowballs
				$TuxDetector.set_deferred("monitoring", false)
				area.get_parent().stomp_bounce()
				death_squish()
				set_deferred("bouncybouncebouncingsnowball", false)
		else:
			death_fall(false)

func _on_tux_detector_body_entered(body):
	if current_state == BadguyStates.DEAD or Global.paused:
		return
	
	if body.is_in_group("Player"):
		await get_tree().create_timer(0.02).timeout # HACK: HACK: HACK: HACK
		interact(body)
	
	if body.is_in_group("Badguy"):
		if not body == self:
			if body.kill_other_enemies:
				death_fall(false)
			if body.kill_self_on_touching_enemy:
				body.death_fall(true)

func _on_dc_timeout():
	if current_state == BadguyStates.DEAD or Global.paused:
		return

	velocity.y = velocity.y * -1
	
	$DirectionChange.start(1.0)

func death_squish():
	if current_state == BadguyStates.DEAD or Global.paused:
		return
	
	current_state = BadguyStates.DEAD
	$TuxDetector.set_deferred("monitoring", false)
	$TuxDetector.set_deferred("monitorable", false)
	set_collision_layer_value(4, true)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	velocity.y = 0
	$Squish.play()
	$Image.play("squished")
	await get_tree().create_timer(death_time).timeout
	queue_free()

func interact(tux):
	if current_state == BadguyStates.DEAD or Global.paused or bouncybouncebouncingsnowball:
		return
	
	if not Global.tux_star_invincible and not get_tux_stomp(tux, false):
		held_badguy_check(true, tux)
	elif Global.tux_star_invincible and not get_tux_stomp(tux, false):
		death_fall(false)
	elif not Global.tux_star_invincible and get_tux_stomp(tux, false):
		death_squish()
