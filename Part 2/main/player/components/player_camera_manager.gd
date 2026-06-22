extends Node
class_name PlayerCameraManager

@export_group("Stats")
@export var mouse_sens: float = 0.005

@export_group("References")
@export var player: Player
@export var cam_root: Node3D
@export var cam: Camera3D


func input_update(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * mouse_sens)
		cam_root.rotate_x(-event.relative.y * mouse_sens)
		cam_root.rotation.x = clampf(cam_root.rotation.x, -PI/2, PI/2)
