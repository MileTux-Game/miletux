extends Marker2D

@export var spawn_name = "main"

func _ready() -> void:
	add_to_group("Spawnpoint")
