extends CharacterBody2D

@export var floating = false
@export var jump_height = 400
@export var speed = 100
var direction = -1

func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)
	$Life.connect("finished", _on_sound_finished)
	
	if not floating:
		velocity.y = -jump_height

func _physics_process(delta: float) -> void:
	if Global.paused:
		velocity = Vector2.ZERO
		return
	if not floating:
		velocity.x = direction * speed
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		Global.coins += 100
		Signals.coin_collected.emit()
		$Image.visible = false
		$Life.play()
	
func _on_sound_finished():
	if Global.paused: # This might cause a bug? Let's see later...
		return
	
	queue_free()
