extends CanvasLayer

func _ready() -> void:
	update_text()
	Signals.coin_collected.connect(update_text)

func update_text():
	$Coins.text = "Coins: " + str(Global.coins)
