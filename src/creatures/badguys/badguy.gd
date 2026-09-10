extends CharacterBody2D
class_name Badguy

enum BadguyStates
{
	ALIVE,
	DEAD,
}

enum IceblockStates
{
	NORMAL,
	FLAT,
	MOVINGFLAT,
	HELD
}

var current_state = BadguyStates.ALIVE

@export var speed = 80
@export var death_time = 2

var kill_other_enemies = false # I'm an idiot
var kill_self_on_touching_enemy = false

var was_on_wall = false

@export var direction = -1

var flammable = true

var smart = false

var current_iceblock_state = IceblockStates.NORMAL
var held_by:CharacterBody2D = null

var jumpy = false # im tired (actually, looking back at this, maybe this was the correct thing to do?)
var bouncybouncebouncingsnowball = false # :(

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Badguy")
	$TuxDetector.add_to_group("BadguyTuxDetector")

func held_badguy_check(stompable:bool, tux):
	if Global.paused:
		return
	
	if not tux.holding_enemy:
		if not Global.tux_star_invincible:
			tux.damage()
		else:
			if stompable:
				death_fall(false)
			else:
				death_fall(true)
	else:
		if stompable:
			death_fall(false)
		else:
			death_fall(false)
		
		tux.held_object.death_fall(true)
		tux.stop_holding()

func death_fall(iceblock:bool):
	if current_state == BadguyStates.DEAD or Global.paused:
		return
	
	current_state = BadguyStates.DEAD
	if iceblock:
		current_iceblock_state = IceblockStates.FLAT # i know this is a hack, i dont want to change it right now
		if not held_by == null:
			held_by.stop_holding()
			held_by = null
		
	$TuxDetector.set_deferred("monitoring", false)
	$TuxDetector.set_deferred("monitorable", false)
	if jumpy: # i'm tired
		$TuxLeftDetector.set_deferred("monitoring", false)
		$TuxLeftDetector.set_deferred("monitorable", false)
		$TuxRightDetector.set_deferred("monitoring", false)
		$TuxRightDetector.set_deferred("monitorable", false)
	velocity.x = 0
	velocity.y = 0
	$Collision.set_deferred("disabled", true)
	$Image.flip_v = true
	$Fall.play()

func death_squish():
	if current_state == BadguyStates.DEAD or Global.paused:
		return
	
	current_state = BadguyStates.DEAD
	$TuxDetector.set_deferred("monitoring", false)
	$TuxDetector.set_deferred("monitorable", false)
	set_collision_layer_value(4, true)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	$Squish.play()
	$Image.play("squished")
	await get_tree().create_timer(death_time).timeout
	queue_free()

# this function exists to be re-used
func get_tux_stomp(tux:CharacterBody2D):
	return tux.get_real_velocity().y > 0
