extends "res://Scripts/Component/Interactable.gd"

func _ready():
	connect("interacted", self, "_on_interact")
	$Speaker.speaker_name = "CEO Grant Blevins"
	#$Speaker.start_dialog("intro_science")

func _on_interact():
	$Speaker.start_dialog("intro_meet_ceo")
