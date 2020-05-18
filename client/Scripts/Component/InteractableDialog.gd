extends "res://Scripts/Component/Interactable.gd"

export var dialog_name : String  = "unconfigured"
export var face_right_init = true
export var face_on_interact = true
export var reset_after_dialog = false

func _ready():
	if $AnimationPlayer:
		$AnimationPlayer.play("Idle")
		$AnimationPlayer.seek(rand_range(0.0, 2.0), true)
	connect("interacted", self, "_on_interact")
	$Speaker.connect("dialog_exited", self, "_on_dialog_exit")
	if $Torso:
		$Torso.flip_h = face_right_init

func _on_interact():
	if $Torso:
		if face_on_interact:
			$Torso.flip_h = global_position.x < player.global_position.x
	$Speaker.start_dialog(dialog_name)

func _on_dialog_exit():
	if $Torso:
		if reset_after_dialog:
			$Torso.flip_h = face_right_init
