extends Node
class_name PlayerWeaponManager

@export_group("References")
@export var weapon: PlayerWeapon
@export var ammo_label: Label
@export var ammo_total_label: Label


func start() -> void:
	update_ui()


func update(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
	
	if Input.is_action_just_pressed("reload"):
		weapon.reload()


func update_ui() -> void:
	ammo_label.text = "%s / %s" % [weapon.ammo, weapon.MAG]
	ammo_total_label.text = str(weapon.ammo_total)
