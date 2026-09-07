extends AnimatedSprite2D

## Scene of your level
@export var level_scene:PackedScene

## Your level's display name. Can be different from the name of the level scene's level.
@export var level_name = "No Name"

## Set this to 1 or more.
@export var level_section = 1

## This turns the level dot blue.
@export var special = false

var completed = false
var tux_on_level = false

func _ready() -> void:
	add_to_group("Level")
	$Detector.connect("body_entered", _on_something_detected)
	$Detector.connect("body_exited", _on_something_exited)

func _physics_process(_delta: float) -> void:
	if Global.paused:
		return
	
	if tux_on_level and Input.is_action_just_pressed("menu_accept"):
		if not Fade.finished.is_connected(_on_fade_finished):
			Fade.connect("finished", _on_fade_finished)
		
		Global.tux_wm_x = get_parent().tux.position.x
		Global.tux_wm_y = get_parent().tux.position.y
		
		Global.save_data()
		Global.current_level = level_scene.resource_path
		
		Fade.fade_in(1)
		Global.paused = true
	
	if completed:
		play("green")
	else:
		if special:
			play("blue")
		else:
			play("red")

func _on_something_detected(body):
	if body.is_in_group("TuxWorldmap"):
		tux_on_level = true
		Global.dot_level_name = level_name
		Signals.update_level_text.emit()

func _on_something_exited(body):
	if body.is_in_group("TuxWorldmap"):
		tux_on_level = false
		Global.dot_level_name = ""
		Signals.update_level_text.emit()

func _on_fade_finished():
	Global.paused = false
	get_tree().call_deferred("change_scene_to_packed", level_scene)

func complete_level():
	if not completed:
		completed = true
		play("green")
