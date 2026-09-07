extends AnimatedSprite2D

func _ready() -> void:
	print("Explosion!!!!!")
	$Detector.connect("body_entered", _on_something_detected)
	$Sound.connect("finished", _on_sound_finished)
	play("default")
	$Sound.play()
	$Particles.emitting = true
	$Particles.connect("finished", _on_particles_finished)

func _on_something_detected(body):
	if Global.paused:
		return
	
	if body.is_in_group("Player"):
		if not Global.tux_star_invincible:
			body.damage()
	if body.is_in_group("Badguy"):
		if body is Iceblock: # TODO: add iceblock variable to badguy instead of doing this weird thing
			body.death_fall(true)
		else:
			body.death_fall(false)

func _on_sound_finished():
	if Global.paused:
		return
	
	print("Explosion gone?????")
	self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Detector.set_deferred("monitoring", false)
	$Detector.set_deferred("monitorable", false)

func _on_particles_finished():
	if Global.paused:
		return
	
	print("Explosion actually gone!!!!!")
	queue_free()
