extends StaticBody2D

## This should be one or more than 1.[br]
## Setting to 0 hasn't been tested.
@export var rock_section = 1

var gone = false

func _ready() -> void:
	add_to_group("Rock")

func remove_rock():
	if not gone:
		gone = true
		queue_free()
