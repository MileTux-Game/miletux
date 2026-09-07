extends CharacterBody2D

@export var affected_by_gravity = true

func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)
	$Image.play("default")

func _physics_process(delta: float) -> void:
	if Global.paused:
		return
	
	if is_on_floor() and affected_by_gravity:
		velocity += get_gravity() * delta
	
	move_and_slide()

func spawn_from_block():
	if Global.paused:
		return
	
	$Collision.set_deferred("disabled", true)
	affected_by_gravity = false
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - 32), 0.8)
	await tween.finished
	$Collision.set_deferred("disabled", false)
	affected_by_gravity = true

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		body.grow("fire_flower")
		queue_free()
