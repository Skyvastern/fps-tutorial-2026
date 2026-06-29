extends Node
class_name PlayerCameraManager

@export_group("Stats")
@export var mouse_sens: float = 0.005

@export_group("References")
@export var player: Player
@export var cam_root: Node3D
@export var cam: Camera3D

var move_x_dir: int = 0:
	set(value):
		if move_x_dir == value:
			return
		
		move_x_dir = value
		
		const ROT_ANGLE: float = 2
		const ANIM_DURATION: float = 0.075
		var target_rot_deg: float = 0
		
		if move_x_dir == 1:
			target_rot_deg = -ROT_ANGLE
		elif move_x_dir == -1:
			target_rot_deg = ROT_ANGLE
		
		# Animate camera's rotation to show weapon swaying
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(cam, "rotation_degrees:z", target_rot_deg, ANIM_DURATION)


func start() -> void:
	player.movement.is_sprinting_changed.connect(_on_is_sprinting_changed)


func input_update(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * mouse_sens)
		cam_root.rotate_x(-event.relative.y * mouse_sens)
		cam_root.rotation.x = clampf(cam_root.rotation.x, -PI/2, PI/2)


func update(_delta: float) -> void:
	move_x_dir = int(Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left"))


func _on_is_sprinting_changed(is_sprinting: bool) -> void:
	var target_fov: float
	
	if is_sprinting:
		target_fov = 90
	else:
		target_fov = 75
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cam, "fov", target_fov, 0.1)
