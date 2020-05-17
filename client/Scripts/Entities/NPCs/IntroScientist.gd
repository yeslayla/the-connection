extends "res://Scripts/Component/Interactable.gd"

export var start_on_play = true

func _ready():
	connect("interacted", self, "_on_interact")
	$Speaker.speaker = "fast_talker"
	$Speaker.speaker_name = "Dr.Thadd"
	$Speaker.connect("dialog_exited", self, "give_tip")
	if start_on_play:
		$Speaker.start_dialog("intro_science")

func _on_interact():
	$Speaker.start_dialog("intro_science_followup")

func give_tip():
	$Speaker.gui.display_tip("Used A & D to move\nleft and right")
	$Speaker.disconnect("dialog_exited", self, "give_tip")
