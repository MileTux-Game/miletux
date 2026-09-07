extends CanvasLayer

func _ready() -> void:
	update_text()
	Signals.update_level_text.connect(update_text)

func update_text():
	$Coins.text = "Coins: " + str(Global.coins)
	$Level.text = Global.dot_level_name
