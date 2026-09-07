extends Node

# The saving / loading stuff is from Tux Mystery

# Level
var level_width = 100
var tile_size = 32
var level_song = ""
var level_name = ""
var level_author = ""
var checkpoint_reached = false
var checkpoint_position = Vector2(0, 0)
var completed_levels = []
var current_level:String

# Tux
var coins:int = 0
var tux_star_invincible = false
var tux_reached_end = false
var tux_state = TuxManager.current_state

# It exists!
var first_worldmap = "res://src/levels/world1/worldmap.tscn"

# Worldmap
var worldmap_name:String
var width_of_worldmap = 0
var height_of_worldmap = 0
var dot_level_name:String
var global_spawn_name = "main"
var use_spawn_point = false
var completed_worldmaps = []
var current_worldmap:String

# Worldmap Tux
var tux_wm_x = 0.0
var tux_wm_y = 0.0

# Options
var particles = true
var level_hud = true
var debug:bool = false:
	set(value):
		debug = value
		set_debug()
var music_playing = true
var sounds = true

## Used instead of get_tree().paused in most cases because it allows animations to continue.
## [br]
## Don't use for worldmap stuff yet.
var paused = false # TODO: Find out why Tux's animations stop when he reaches the goal, likely has something to do with this function.

# Save file
var save_version = 1
var save_path = "user://save.json"

func _ready() -> void:
	load_data()

func set_debug():
	if debug:
		print("debug: " + str(debug))
		OS.alert("Debug Mode is enabled!\nRead the GitHub repository's wiki for more information.", "Debug Mode")
	else:
		print("debug: " + str(debug)) # there will be more stuff here soon

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save_debug"):
		save_data()
	if Input.is_action_just_pressed("load_debug"):
		load_data()

func save_data():
	var data = {
		"completed_levels": completed_levels,
		"coins": coins,
		"current_worldmap": current_worldmap,
		"completed_worldmaps": completed_worldmaps,
		"tux_wm_x": tux_wm_x,
		"tux_wm_y": tux_wm_y,
		"particles": particles,
		"level_hud": level_hud,
		"debug": debug,
		"music_playing": music_playing,
		"sounds": sounds,
		"save_version": save_version
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data)
		file.store_string(json_string)
		file.close()
		print("Game saved!")

func load_data():
	if not FileAccess.file_exists(save_path):
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			var data = json.get_data()
			if data.has("completed_levels"):
				completed_levels = data["completed_levels"]
				coins = data["coins"]
				current_worldmap = data["current_worldmap"]
				completed_worldmaps = data["completed_worldmaps"]
				tux_wm_x = data["tux_wm_x"]
				tux_wm_y = data["tux_wm_y"]
				particles = data["particles"]
				level_hud = data["level_hud"]
				debug = data["debug"]
				music_playing = data["music_playing"]
				sounds = data["sounds"]
				save_version = data["save_version"]
				
				print("Game loaded!")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.tux_state = TuxManager.current_state
		get_tree().quit()
