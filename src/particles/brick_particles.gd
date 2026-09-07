extends Node2D

var snow = false
var snow_brick_path = "res://data/images/objects/brick/brick1.png"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if snow:
		$One.texture = load(snow_brick_path)
		$Two.texture = load(snow_brick_path)
		$Three.texture = load(snow_brick_path)
		$Four.texture = load(snow_brick_path)
	$DisappearTimer.connect("timeout", _on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.paused:
		return
	
	$One.position += Vector2(-100, -400) * delta
	$Two.position += Vector2(100, -400) * delta
	$Three.position += Vector2(-150, -300) * delta
	$Four.position += Vector2(150, -300) * delta

func _on_timer_timeout():
	if Global.paused:
		return
	
	queue_free()
