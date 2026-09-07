extends Node2D

@export var intro = false
@export_file("*.ogg") var music = "res://data/music/credits.ogg"

func _ready() -> void:
	if not intro:
		Music.stream = load(music)
		Music.play()
