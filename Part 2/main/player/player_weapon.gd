extends Node3D
class_name PlayerWeapon

enum WeaponState {
	Idle,
	Shooting,
	Reloading
}

var state: WeaponState = WeaponState.Idle

@export_group("Stats")
@export var shoot_range: float = 1000
@export var ammo_total: int = 30
@export var ammo: int = 15
const MAG: int = 15

@export_group("References")
@export var weapon_mg: PlayerWeaponManager
@export var anim_player: AnimationPlayer
@export var muzzle_flash: GPUParticles3D
@export var impact_effect_scene: PackedScene


func _ready() -> void:
	anim_player.animation_finished.connect(_on_anim_finish)


func _on_anim_finish(_anim_name: StringName) -> void:
	state = WeaponState.Idle
	anim_player.play("idle")


func shoot() -> void:
	if state == WeaponState.Reloading:
		return
	
	state = WeaponState.Shooting
	
	if ammo > 0:
		anim_player.play("shoot")
	else:
		anim_player.play("shoot_empty")


# Called via animation
func shoot_bullet() -> void:
	# Consume ammo
	ammo -= 1
	weapon_mg.update_ui()
	
	# 2. Play SFX
	
	# 3. Play Muzzle Effect
	muzzle_flash.emitting = true
	
	# 4. Detecting Hit
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var from: Vector3 = Global.player.camera_mg.cam.global_position
	var to: Vector3 = from - (Global.player.camera_mg.cam.global_transform.basis.z * shoot_range)
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to, 1, [self])
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		var collide_pos: Vector3 = result.position
		
		# Show the impact effect
		var impact_effect: GPUParticles3D = impact_effect_scene.instantiate()
		get_tree().current_scene.add_child(impact_effect)
		impact_effect.global_position = collide_pos
		impact_effect.emitting = true
	else:
		pass


# Called via animation
func shoot_bullet_empty() -> void:
	Global.warning_msg.show_message("Ammo is empty, please reload.")


func reload() -> void:
	if ammo == MAG:
		return
	
	if ammo_total <= 0:
		return
	
	if state == WeaponState.Shooting:
		anim_player.stop()
	
	state = WeaponState.Shooting
	anim_player.play("reload")


# Called via animation
func reload_ammo() -> void:
	var ammo_needed: int = MAG - ammo
	
	if ammo_needed < ammo_total:
		ammo += ammo_needed
		ammo_total -= ammo_needed
	else:
		ammo = ammo_total
		ammo_total = 0
	
	weapon_mg.update_ui()
	Global.warning_msg.hide_message()
