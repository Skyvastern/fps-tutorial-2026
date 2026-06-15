extends CharacterBody3D
class_name Player

@export_group("Components")
@export var camera_mg: PlayerCameraManager
@export var movement: PlayerMovement


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	camera_mg.input_update(event)


func _physics_process(delta: float) -> void:
	movement.physics_update(delta)
