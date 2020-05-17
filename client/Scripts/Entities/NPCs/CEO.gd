extends "res://Scripts/Component/Interactable.gd"

var state : int = 0

func _ready():
	connect("interacted", self, "_on_interact")
	$Speaker.speaker_name = "CEO Grant Blevins"
	$Speaker.speaker = "ceo"
	$Speaker.connect("dialog_exited", self, "_on_dialog_exit")

func _on_interact():
	if state == 0:
		$Speaker.start_dialog("intro_meet_ceo")
		if player:
			player.clearance_level = 1
	else:
		$Speaker.start_dialog("into_speak_ceo")

func _on_dialog_exit():
	if state == 0:
		state = 1
		$Speaker.gui.display_tip("Press S and then SPACE\nto go down platforms")
