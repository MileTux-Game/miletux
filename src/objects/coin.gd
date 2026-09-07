extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
	$TuxDetector.connect("body_entered", _on_something_detected)
	$Sound.connect("finished", _on_sound_finished)

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player") and not body.dead:
		$TuxDetector.set_deferred("monitoring", false)
		$Animation.play("collect")
		$Sound.play()
		Global.coins += 1
		Signals.coin_collected.emit()

func _on_sound_finished():
	queue_free()

func set_from_block():
	if Global.paused:
		return
	
	$TuxDetector.set_deferred("monitoring", false)
	$Animation.play("collect")
	Global.coins += 1
	Signals.coin_collected.emit()
