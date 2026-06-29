extends Label
class_name WarningMessage

@export var anim_player: AnimationPlayer


func _enter_tree() -> void:
	Global.warning_msg = self


func _ready() -> void:
	anim_player.animation_finished.connect(_on_anim_finished)
	
	hide_message()


func show_message(message: String) -> void:
	text = message
	
	anim_player.stop()
	anim_player.play("show")
	visible = true


func hide_message() -> void:
	visible = false


func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "show":
		visible = false
