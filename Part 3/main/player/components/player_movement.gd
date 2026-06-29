extends Node
class_name PlayerMovement

signal is_sprinting_changed

@export_group("Stats")
@export var speed: float = 10
@export var sprint_speed: float = 20
@export var jump_speed: float = 25
@export var gravity: float = 100

@export_group("References")
@export var player: Player

var is_sprinting: bool = false:
	set(value):
		if is_sprinting == value:
			return
		
		is_sprinting = value
		is_sprinting_changed.emit(is_sprinting)


func physics_update(delta: float) -> void:
	# Jump
	if player.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			player.velocity.y = jump_speed
	# Gravity
	else:
		player.velocity.y -= gravity * delta
	
	# Movement
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var dir: Vector3 = player.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	dir = dir.normalized()
	
	is_sprinting = Input.is_action_pressed("sprint")
	
	player.velocity.x = dir.x * _get_speed()
	player.velocity.z = dir.z * _get_speed()
	player.move_and_slide()


func _get_speed() -> float:
	if is_sprinting:
		return sprint_speed
	else:
		return speed
