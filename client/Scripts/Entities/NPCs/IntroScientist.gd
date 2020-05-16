extends "res://Scripts/Component/Interactable.gd"

func _ready():
	connect("interacted", self, "_on_interact")
	$Speaker.speaker = "fast_talker"
	$Speaker.speaker_name = "Dr.Thadd"
	$Speaker.start_dialog("intro_science")

func _on_interact():
	$Speaker.start_dialog("intro_science_followup")

