extends CanvasLayer

## Emitted when any function in fade.gd is done except _enter_tree().
signal finished

# Sets visible to false. Simple!
func _enter_tree() -> void:
	$Animation.play("invisible")
	visible = false

## Fades in. Speed is how fast / slow it is to fade in.
## [br]
## Also emits finished.
func fade_in(speed:float):
	visible = true
	$Animation.play("fade_in", -1, speed)
	await $Animation.animation_finished
	finished.emit()

## Fades out. Speed is how fast / slow it is to fade out.
## [br]
## Also emits finished.
func fade_out(speed:float):
	visible = true
	$Animation.play("fade_out", -1, speed)
	await $Animation.animation_finished
	finished.emit()

## Resets to black.
## [br]
## Also emits finished.
func reset_to_black():
	visible = true
	$Animation.play("RESET")
	await $Animation.animation_finished # just to be safe
	finished.emit()

## Turns invisible. Every other function (except _enter_tree()) makes it visible, including reset_to_black.
## [br]
## Also emits finished.
func turn_invisible():
	visible = false
	$Animation.play("invisible")
	await $Animation.animation_finished
	finished.emit()
