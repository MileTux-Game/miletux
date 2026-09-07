extends Node2D

@export_file("*.ogg") var music = "res://data/music/theme.ogg"
@export_file("*.tscn") var intro_scene = "res://src/menu/intro.tscn"
@export_file("*.tscn") var credits_scene = "res://src/menu/credits.tscn"

func _ready() -> void:
	Music.stream = load(music)
	Music.play()
	$Panel/VBoxContainer/Play.connect("pressed", _on_play_pressed)
	$Panel/VBoxContainer/BonusLevels.connect("pressed", _on_bonus_pressed)
	$Panel/VBoxContainer/Options.connect("pressed", _on_options_pressed)
	$Panel/VBoxContainer/Credits.connect("pressed", _on_credits_pressed)
	$Panel/VBoxContainer/Exit.connect("pressed", _on_exit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file(intro_scene)

func _on_bonus_pressed():
	pass

func _on_options_pressed():
	pass

func _on_credits_pressed():
	get_tree().change_scene_to_file(credits_scene)

func _on_exit_pressed():
	get_tree().quit(0)
