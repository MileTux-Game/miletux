extends Node

signal coin_collected
signal level_finished
signal update_level_text

## Never call this function! This is just here to prevent warnings.
func no_more_warning():
	coin_collected.emit()
	level_finished.emit()
	update_level_text.emit()
