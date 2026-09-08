extends Badguy

var ground_detector_x_left = -3.0
var ground_detector_x_right = 35.0

var gd_was_colliding = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TuxDetector.connect("body_entered", _on_tux_detector_body_entered)
	$Image.play("walk")
	super()

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity = Vector2.ZERO
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if current_state == BadguyStates.ALIVE:
		velocity.x = direction * speed
		
		if direction == -1:
			$GroundDetector.position.x = -3.0
		else:
			$GroundDetector.position.x = 35.0
		
		if not $GroundDetector.is_colliding() and is_on_floor() and gd_was_colliding:
			flip_direction()
	else:
		velocity.x = 0
	
	if is_on_wall() and not was_on_wall:
		flip_direction()
	
	if direction == 1:
		$Image.flip_h = true
	else:
		$Image.flip_h = false
	
	was_on_wall = is_on_wall()
	gd_was_colliding = $GroundDetector.is_colliding()
	
	move_and_slide()

func flip_direction():
	direction = -direction

func _on_tux_detector_body_entered(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player"):
		if not Global.tux_star_invincible:
			held_badguy_check(false, body)
		else:
			death_fall(false)
	if body.is_in_group("Badguy"):
		if not body == self:
			if body.kill_other_enemies:
				death_fall(false)
			if body.kill_self_on_touching_enemy:
				body.death_fall(true)
