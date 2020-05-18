extends "res://Scripts/Component/Interactable.gd"

export var start_on_play = true

func _ready():
	connect("interacted", self, "_on_interact")
	$AnimationPlayer.play("Idle")
	$AnimationPlayer.seek(rand_range(0.0, 2.0), true)
	$Speaker.speaker = "fast_talker"
	$Speaker.speaker_name = "Dr.Thadd"
	$Speaker.connect("dialog_exited", self, "give_tip")
	if start_on_play:
		$Speaker.start_dialog("intro_science")

func _on_interact():
	$Speaker.start_dialog("intro_science_followup")
	$Torso.flip_h = global_position.x < player.global_position.x

func give_tip():
	$Speaker.gui.display_tip("Used A & D to move\nleft and right")
	$Speaker.disconnect("dialog_exited", self, "give_tip")
