extends CharacterBody2D

@export var speed = 128

var current_state:TuxManager.TuxStates

func _ready() -> void:
	add_to_group("TuxWorldmap")
	reload_player()

func _physics_process(_delta: float) -> void:
	if Global.paused:
		return
	
	if position.x < 0:
		position.x = 0
	
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	velocity = direction * speed
	
	if not velocity == Vector2.ZERO:
		velocity = velocity.normalized() * speed
	
	if not velocity == Vector2.ZERO:
		$Image.play("walk")
		$FireImage.play("walk")
	else:
		$Image.play("stand")
		$FireImage.play("stand")
	
	move_and_slide()

func reload_player():
	if current_state == TuxManager.TuxStates.FIRE:
		$Image.visible = false
		$FireImage.visible = true
	else:
		$Image.visible = true
		$FireImage.visible = false
