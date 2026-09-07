extends Area2D

@export_enum("End Sequence", "Stop Tux") var type = 0
@export_file("*.ogg") var leveldone_song = "res://data/music/leveldone.ogg"
@export var leveldone_length = 7.71

func _ready() -> void:
	connect("body_entered", _on_something_detected)

func _on_something_detected(body):
	if body.is_in_group("Player"):
		match(type):
			0: # End Sequence
				if not Global.tux_reached_end:
					Global.tux_reached_end = true
					body.in_cutscene = true
					body.auto_walk = true
					body.auto_walk_speed = body.walk_speed
					body.duck = false
					body.skid = false
					body.can_take_damage = false
					body.get_star_lite()
					body.change_image_direction(1)
					Music.stream = load(leveldone_song)
					Music.play()
					Global.level_song = leveldone_song # HACK that will probably break something in the future
					Engine.time_scale = 0.5
					await Music.finished
					Signals.level_finished.emit()
			1: # Stop Tux
				if not Global.tux_reached_end:
					Global.tux_reached_end = true
					body.get_star_lite()
					Global.paused = true
					body.velocity = Vector2.ZERO
					Music.stream = load(leveldone_song)
					Music.play()
					Global.level_song = leveldone_length # Again, HACK!!!!!
					await Music.finished
					Signals.level_finished.emit()
				else:
					Global.paused = true
					body.velocity = Vector2.ZERO
