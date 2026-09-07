extends Badguy
class_name Bomb

const explosion_scene = preload("res://src/creatures/badguys/explosion.tscn")

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
		
		if get_tux_stomp(area.get_parent()):
			if not Global.tux_star_invincible:
				area.get_parent().stomp_bounce()
				death_squish()
			else:
				death_squish()

func _on_tux_detector_body_entered(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player"):
		held_badguy_check(true, body)
	if body.is_in_group("Badguy"):
		if not body == self:
			if body.kill_other_enemies:
				death_fall(false)
			if body.kill_self_on_touching_enemy:
				body.death_fall(true)

func death_fall(_iceblock:bool):
	if Global.paused:
		return
	
	explode()

func death_squish():
	if current_state == BadguyStates.DEAD or Global.paused:
		return
	
	current_state = BadguyStates.DEAD
	$TuxDetector.set_deferred("monitoring", false)
	$TuxDetector.set_deferred("monitorable", false)
	set_collision_layer_value(4, true)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	$Squish.play()
	$Image.play("ticking")
	$Fizz.play()
	$Tick.play()
	await $Image.animation_finished
	explode()

func explode():
	if Global.paused:
		return
	
	var explosion = explosion_scene.instantiate()
	explosion.global_position.x = global_position.x
	explosion.global_position.y = global_position.y
	get_tree().current_scene.call_deferred("add_child", explosion)
	queue_free()
