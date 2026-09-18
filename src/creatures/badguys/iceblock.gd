extends Badguy
class_name Iceblock

# MileTux

# Iceblock - A basic walking enemy that, when stomped, can be held, thrown and/or kicked.
# Copyright (C) 2006 Matthias Braun <matze@braunis.de>
# Copyright (C) 2023 Vankata453
# Copyright (C) 2026 Sophie Ball <sophieballvaesea@proton.me>
#
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

var wait_to_collide = 0.0

var previous_velocity_x = 0

var bounce_timer = 0.0

@export var movingflat_speed = 350

@export var image_offset_x_left = 38.0 # 32 + image_offset_x_right because why not? it looks decent enough
@export var image_offset_x_right = 6.0

@export var ground_detector_x_left = -3.0
@export var ground_detector_x_right = 34.0

var gd_was_colliding = true

@export var wait_time = 0.25

func _ready() -> void:
	$TuxDetector.connect("area_entered", _on_td_area_entered)
	$TuxDetector.connect("body_entered", _on_td_body_entered)
	$Notifier.connect("screen_entered", _on_screen_entered)
	$Notifier.connect("screen_exited", _on_screen_exited)
	super()

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity.x = 0
		velocity.y = 0
		return
	
	if wait_to_collide > 0:
		wait_to_collide -= delta
	
	if not is_on_floor() and not current_iceblock_state == IceblockStates.HELD:
		velocity += get_gravity() * delta
	
	if current_iceblock_state == IceblockStates.NORMAL and not $Notifier.is_on_screen():
		set_physics_process(false)
	
	if current_iceblock_state == IceblockStates.MOVINGFLAT:
		kill_other_enemies = true
		kill_self_on_touching_enemy = false
		set_collision_mask_value(1, true)
		set_collision_mask_value(9, true)
		set_collision_layer_value(3, false)
		set_collision_mask_value(3, false)
		set_collision_layer_value(5, true)
	elif current_iceblock_state == IceblockStates.HELD:
		kill_other_enemies = true
		kill_self_on_touching_enemy = true
		set_collision_mask_value(1, false)
		set_collision_mask_value(9, false)
		set_collision_layer_value(3, false)
		set_collision_mask_value(3, false)
		set_collision_layer_value(5, true)
	else:
		kill_other_enemies = false
		kill_self_on_touching_enemy = false
		set_collision_mask_value(1, true)
		set_collision_mask_value(9, true)
		set_collision_layer_value(3, true)
		set_collision_mask_value(3, true)
		set_collision_layer_value(5, false)
	
	if current_state == BadguyStates.ALIVE:
		if direction == -1:
			$GroundDetector.position.x = ground_detector_x_left
		else:
			$GroundDetector.position.x = ground_detector_x_right
		
		if not $GroundDetector.is_colliding() and is_on_floor() and gd_was_colliding and current_iceblock_state == IceblockStates.NORMAL:
			flip_direction()
	
	if current_iceblock_state == IceblockStates.HELD and not held_by == null:
		if TuxManager.direction == -1:
			direction = -1
			global_position.x = held_by.global_position.x - image_offset_x_left
		else:
			direction = 1
			global_position.x = held_by.global_position.x + image_offset_x_right
		
		if TuxManager.current_state == TuxManager.TuxStates.SMALL:
			global_position.y = held_by.global_position.y - (held_by.get_node("Collision").shape.size.y / 8)
		else:
			global_position.y = held_by.global_position.y - (held_by.get_node("Collision").shape.size.y / 4)
	
	animate()
	move()
	
	# These were moved to be after the move function to fix a bug.
	if is_on_wall() and not current_iceblock_state == IceblockStates.FLAT:
		if velocity.x * get_wall_normal().x < 0:
			flip_direction()
	if current_iceblock_state == IceblockStates.MOVINGFLAT and is_on_wall():
		if velocity.x * get_wall_normal().x < 0:
			$Ricochet.play()
	
	previous_velocity_x = velocity.x
	gd_was_colliding = $GroundDetector.is_colliding()
	
	move_and_slide()

func animate():
	if Global.paused:
		return
	
	if current_iceblock_state == IceblockStates.NORMAL:
		if current_state == BadguyStates.ALIVE:
			$Image.play("walk")
		else:
			$Image.play("flat")
	else:
		$Image.play("flat")
	
	if direction == -1:
		$Image.flip_h = false
	else:
		$Image.flip_h = true

func flip_direction():
	direction = -direction

func move():
	if Global.paused:
		return
	
	if not current_state == BadguyStates.DEAD:
		if current_iceblock_state == IceblockStates.NORMAL:
			velocity.x = direction * speed
		elif current_iceblock_state == IceblockStates.FLAT or current_iceblock_state == IceblockStates.HELD:
			velocity.x = 0
			if current_iceblock_state == IceblockStates.HELD:
				velocity.y = 0
		elif current_iceblock_state == IceblockStates.MOVINGFLAT:
			velocity.x = direction * movingflat_speed

func _on_td_area_entered(area):
	if Global.paused:
		return
	
	if area.is_in_group("Stomp") and not current_state == BadguyStates.DEAD:
		interact(area, null, null, null)
	if area.is_in_group("TuxDetector") and not area.get_parent() == self:
		interact(null, null, null, area.get_parent())

func _on_td_body_entered(body):
	if Global.paused:
		return
	
	if (body.is_in_group("Player") and current_iceblock_state == IceblockStates.HELD) or current_state == BadguyStates.DEAD:
		return
	
	if body.is_in_group("Player") and not wait_to_collide > 0:
		interact(null, body, null, null)
	elif body.is_in_group("Badguy") and not body == self:
		interact(null, null, null, body)

func interact(stomp, tux, fireball, iceblock): # TODO: Add Fireball bullets later
	if Global.paused:
		return
	
	if not stomp == null and tux == null and fireball == null and iceblock == null:
		if current_state == BadguyStates.DEAD:
			return
		
		if get_tux_stomp(stomp.get_parent()):
			if not Global.tux_star_invincible:
				stomp.get_parent().stomp_bounce()
			else:
				death_fall(true)
				stomp.get_parent().stop_holding()
				return
			
			if wait_to_collide <= 0:
				if current_iceblock_state == IceblockStates.NORMAL or current_iceblock_state == IceblockStates.MOVINGFLAT:
					turn_flat()
				elif current_iceblock_state == IceblockStates.FLAT:
					if stomp.get_parent().global_position.x < global_position.x + 16:
						turn_movingflat(1)
					elif stomp.get_parent().global_position.x > global_position.x + 16:
						turn_movingflat(-1)
					elif stomp.get_parent().global_position.x == global_position.x + 16:
						turn_movingflat(1)
	if stomp == null and not tux == null and fireball == null and iceblock == null:
		if wait_to_collide <= 0:
			if current_iceblock_state == IceblockStates.MOVINGFLAT or current_iceblock_state == IceblockStates.NORMAL:
				if not get_tux_stomp(tux):
					held_badguy_check(false, tux)
			elif current_iceblock_state == IceblockStates.FLAT:
				if Input.is_action_pressed("player_action") and tux.held_object == null:
					if not Global.tux_star_invincible:
						tux.hold_object(self)
					else:
						death_fall(true)
				else:
					if not Global.tux_star_invincible:
						turn_movingflat(TuxManager.direction)
					else:
						death_fall(true)
			else:
				if not Global.tux_star_invincible:
					turn_movingflat(TuxManager.direction) # i honestly forgot why this is here
				else:
					death_fall(true)
	if stomp == null and tux == null and not fireball == null and iceblock == null:
		fireball.queue_free()
		death_fall(true)
	if stomp == null and tux == null and fireball == null and not iceblock == null:
		if iceblock == self:
			print(":(")
			return
		
		if not iceblock is Iceblock: # HACK?
			print(":-(")
			return
		
		if current_iceblock_state == IceblockStates.MOVINGFLAT:
			if iceblock.current_iceblock_state == IceblockStates.MOVINGFLAT:
				iceblock.death_fall(true)
				death_fall(true)
				return
			iceblock.death_fall(true)
			return
		
		if current_iceblock_state == IceblockStates.HELD:
			iceblock.death_fall(true)
			death_fall(true)

func turn_movingflat(dir:int):
	if Global.paused:
		return
	
	current_iceblock_state = IceblockStates.MOVINGFLAT
	direction = dir
	velocity.x = direction * movingflat_speed
	wait_to_collide = wait_time
	set_collision_layer_value(3, false)
	set_collision_layer_value(5, true)
	$Kick.play()

func turn_flat():
	if Global.paused:
		return
	
	current_iceblock_state = IceblockStates.FLAT
	velocity.x = 0
	wait_to_collide = wait_time
	set_collision_layer_value(3, true)
	set_collision_layer_value(5, false)
	$Stomp.play()

func pick_up(tux:CharacterBody2D):
	if Global.paused:
		return
	
	current_iceblock_state = IceblockStates.HELD
	held_by = tux

func throw():
	if Global.paused:
		return
	
	turn_movingflat(TuxManager.direction)
	held_by = null

func _on_screen_entered():
	if Global.paused:
		return
	
	set_physics_process(true)

func _on_screen_exited():
	if Global.paused:
		return
	
	if not current_iceblock_state == IceblockStates.MOVINGFLAT:
		set_physics_process(false)
