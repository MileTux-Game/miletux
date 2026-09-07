extends Badguy
class_name BouncingSnowball

var bounce_height = 450

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TuxDetector.connect("area_entered", _on_tux_detector_area_entered)
	$TuxDetector.connect("body_entered", _on_tux_detector_body_entered)
	$Image.play("walk")
	$TuxDetector.add_to_group("BouncingEnemyTuxDetector")
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
		if is_on_floor():
			velocity.y = -bounce_height
	else:
		velocity.x = 0
	
	if is_on_wall() and not was_on_wall:
		flip_direction()
	
	if direction == 1:
		$Image.flip_h = true
	else:
		$Image.flip_h = false
	
	was_on_wall = is_on_wall()
	
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
			if get_tux_stomp(area.get_parent()):
				bouncybouncebouncingsnowball = true
				area.get_parent().position.y -= 1 # i hate bouncing snowballs
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
	if current_state == BadguyStates.DEAD or Global.paused:
		return
	
	if bouncybouncebouncingsnowball:
		return

	if not Global.tux_star_invincible:
		held_badguy_check(true, tux)
	else:
		death_fall(false)
