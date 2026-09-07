extends Button

func _process(_delta: float) -> void:
	if button_pressed:
		set_button_icon(load("res://data/images/objects/coin/coin-0.png"))
	else:
		icon = null
