extends Marker2D

@export var spawnpoint_name = "main"

func _ready() -> void:
	add_to_group("TuxSpawnpoint")
