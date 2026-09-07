extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Detector.connect("body_entered", _on_something_detected)
	if not Global.checkpoint_reached:
		play("normal")
	else:
		play("ring")

func _on_something_detected(body):
	if body.is_in_group("Player") and not Global.checkpoint_reached:
		print("Checkpoint reached!")
		play("ring")
		Global.checkpoint_reached = true
		Global.checkpoint_position = position
