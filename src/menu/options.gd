extends Node2D

@export_file("*.ogg") var music = "res://data/music/options.ogg"
@export_file("*.tscn") var main_menu = "res://src/menu/main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.stream = load(music)
	Music.play()
	$Panel/VBoxContainer/Particles.connect("toggled", _on_particles_toggled)
	$Panel/VBoxContainer/LevelHUD.connect("toggled", _on_level_hud_toggled)
	$Panel/VBoxContainer/DebugMode.connect("toggled", _on_debug_toggled)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_exit"):
		get_tree().change_scene_to_file(main_menu)

func _on_particles_toggled(toggled_on:bool):
	if toggled_on:
		Global.particles = true
	else:
		Global.particles = false

func _on_level_hud_toggled(toggled_on:bool):
	if toggled_on:
		Global.level_hud = true
	else:
		Global.level_hud = false

func _on_debug_toggled(toggled_on:bool):
	if toggled_on:
		Global.debug = true
	else:
		Global.debug = false
