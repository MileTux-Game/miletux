extends CharacterBody2D
class_name Stalactite

enum States 
{
	NORMAL, 
	SHAKE, 
	FALL, 
	DEAD
}

var current_state:States = States.NORMAL

var crack_sound_played = false

@export var flammable = true
@export var shake_timer = 0.8
@export var death_timer = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Stalactite")
	$Image.play("normal")
	$Animation.play("RESET")
	$Detector.add_to_group("StalactiteDetector")
	$Detector.connect("body_entered", _on_detector_body_entered)

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity = Vector2.ZERO # oops! just remembered i could do this! TODO: Use this instead of setting both velocitys to 0 separately
		return
	
	match(current_state):
		0: # NORMAL
			velocity.y = 0
		1: # SHAKE
			velocity.y = 0
		2: # FALL
			velocity += get_gravity() * delta
		3: # DEAD
			velocity.y = 0
	
	if current_state == States.NORMAL:
		$FloorDetector.target_position.y = 512.0
		
		$FloorDetector.force_shapecast_update()
		
		if $FloorDetector.is_colliding():
			$FloorDetector.target_position.y = $FloorDetector.get_collision_point(0).y - $FloorDetector.global_position.y
			if $FloorDetector.get_collider(0):
				if $FloorDetector.get_collider(0).is_in_group("Player"):
					start_falling(false)
		
	if current_state == States.FALL:
		if is_on_floor():
			death()
		
	move_and_slide()

func _on_detector_body_entered(body):
	if Global.paused:
		return
	
	if body.is_in_group("Badguy"):
		if body is Iceblock:
			body.death_fall(true)
		else:
			body.death_fall(false)
	
	if body.is_in_group("Player"):
		body.damage()
	
	if body.is_in_group("Fireball"):
		body.queue_free()
		start_falling(true)

func start_falling(fireball:bool):
	if Global.paused:
		return
	
	if flammable:
		flammable = false
	
	if fireball:
		$Melt.play()
	
	if current_state == States.NORMAL:
		current_state = States.SHAKE
		$FloorDetector.enabled = false
		$FloorDetector.visible = false
		$Animation.play("shake")
		if not $Cracking.playing or not crack_sound_played:
			$Cracking.play()
			crack_sound_played = true
		await get_tree().create_timer(shake_timer).timeout
		$Animation.play("RESET")
		current_state = States.FALL

func death():
	if current_state == States.DEAD or Global.paused:
		return
	
	z_index = 1
	$Detector.set_deferred("monitoring", false)
	$Detector.set_deferred("monitorable", false)
	current_state = States.DEAD
	$Crash.play(0.17)
	$Image.play("broken")
	await get_tree().create_timer(death_timer).timeout
	queue_free()
