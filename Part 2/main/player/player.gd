extends CharacterBody3D
class_name Player

@export_group("Components")
@export var camera_mg: PlayerCameraManager
@export var movement: PlayerMovement
@export var weapon_mg: PlayerWeaponManager


func _enter_tree() -> void:
	Global.player = self


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	weapon_mg.start()


func _input(event: InputEvent) -> void:
	camera_mg.input_update(event)


func _process(delta: float) -> void:
	weapon_mg.update(delta)


func _physics_process(delta: float) -> void:
	movement.physics_update(delta)
