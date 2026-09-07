extends Node2D
class_name Worldmap

# Made by AnatolyStev, ported to Godot for GodotTux by Vaesea and AnatolyStev

# Note from AnatolyStev all the way back in GodotTux: "Play Supertux Free NOW Online Games for All Ages SuperTux Platforming Fun 2020"

@export var license = "CC-BY-SA 4.0"
@export var worldmap_width = 100
@export var worldmap_height = 100
@export_file("*.ogg") var music = "res://data/music/salcon.ogg"

var levels:Array = []
var rocks:Array = []

const hud = preload("res://src/hud/worldmap_hud.tscn")

# for the level node
@onready var tux = $WorldmapTux

func _ready() -> void:
	Global.current_worldmap = scene_file_path
	Global.width_of_worldmap = worldmap_width * Global.tile_size
	Global.height_of_worldmap = worldmap_height * Global.tile_size
	
	$WorldmapTux/Camera2D.limit_bottom = Global.height_of_worldmap
	$WorldmapTux/Camera2D.limit_right = Global.width_of_worldmap
	
	Music.stream = load(music)
	Music.play()
	
	tux.current_state = Global.tux_state
	tux.reload_player()
	
	var hud_2 = hud.instantiate()
	get_tree().current_scene.add_child(hud_2)
	
	levels = get_tree().get_nodes_in_group("Level")
	rocks = get_tree().get_nodes_in_group("Rock")
	
	if Global.use_spawn_point:
		if get_spawn_point(Global.global_spawn_name):
			tux.position = get_spawn_point(Global.global_spawn_name).position
		Global.use_spawn_point = false
	else:
		if Global.tux_wm_x == 0 and Global.tux_wm_y == 0:
			tux.position = Vector2($MainWorldmapSpawnPoint.position.x, $MainWorldmapSpawnPoint.position.y)
		else:
			tux.position = Vector2(Global.tux_wm_x, Global.tux_wm_y)
	
	check_rock_unlocks() # The Rock
	check_levels_completed() # The Level

func section_completed(section:int):
	for level in levels:
		if level.level_section == section and not level.level_scene.resource_path in Global.completed_levels: # Breaking rules
			return false
	
	return true

func check_rock_unlocks():
	for rock in rocks:
		if rock.gone:
			continue
		
		if section_completed(rock.rock_section):
			rock.remove_rock()

# you simply move the s!
func check_levels_completed():
	for level in levels:
		if level.level_scene.resource_path in Global.completed_levels:
			level.complete_level()

# SPAWN
func get_spawn_point(name_of_spawn:String):
	for spawn in get_tree().get_nodes_in_group("Spawnpoint"):
		if spawn.spawn_name == name_of_spawn:
			return spawn
	
	return null

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.tux_wm_x = tux.position.x
		Global.tux_wm_y = tux.position.y
		Global.tux_state = TuxManager.current_state
		Global.save_data()
		get_tree().quit()
