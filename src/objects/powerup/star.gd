extends CharacterBody2D

var direction = 1
var speed = 150
var initial_jump = 400
var jump_height = 300
var was_on_wall = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity = Vector2.ZERO
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		velocity.y = -jump_height
	
	velocity.x = direction * speed
	
	if is_on_wall() and not was_on_wall:
		flip_direction()
	
	was_on_wall = is_on_wall()
	
	move_and_slide()

func flip_direction():
	direction = -direction

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		body.get_star()
		queue_free()

func spawn_from_block(go_to_direction:int):
	if Global.paused:
		return
	
	velocity.y = -initial_jump
	direction = go_to_direction
