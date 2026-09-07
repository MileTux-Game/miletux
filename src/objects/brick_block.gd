@tool
extends Block

@export var empty_brick = true:
	set(value):
		empty_brick = value
		reload_graphics()

@export var how_many_hits = 5
@export var snow = false:
	set(value):
		snow = value
		reload_graphics()

func _ready() -> void:
	if not Engine.is_editor_hint():
		brick = true
		reload_graphics()
		super()

func reload_graphics():
	if snow:
		$Image.play("snow")
	else:
		$Image.play("normal")
	
	if Engine.is_editor_hint():
		if empty_brick:
			$CoinImage.visible = false
		else:
			$CoinImage.visible = true
	else:
		$CoinImage.visible = false

func _physics_process(_delta: float) -> void:
	if not empty_brick and how_many_hits <= 0 and not Engine.is_editor_hint():
		if Global.paused:
			return
		
		$Image.play("empty")

func _on_dd_body_entered(body):
	if not Engine.is_editor_hint():
		if Global.paused:
			return
		
		if body.is_in_group("Player") and not body.dead:
			if empty_brick:
				$BrickSound.play()
				if TuxManager.current_state == TuxManager.TuxStates.SMALL:
					$Animation.play("up_down")
					bump = true
					detect_enemies()
				else:
					$Animation.play("up_gone")
					bump = true
					detect_enemies()
			else:
				$BrickSound.play()
				if how_many_hits > 0:
					$Animation.play("up_down")
					how_many_hits -= 1
					spawn_item(ItemDirections.LEFT)
					bump = true
					detect_enemies()

func spawn_item(_direction:ItemDirections):
	if Global.paused:
		return
	
	if content == 0:
		spawn_coin()
	else:
		print("Can't do that.")

func spawn_brick_particles():
	if Global.paused:
		return
	
	var brick_particles = brick_particles_scene.instantiate()
	
	if snow:
		brick_particles.snow = true
	
	get_tree().current_scene.call_deferred("add_child", brick_particles)
	brick_particles.global_position = self.global_position
