extends "res://Scripts/Component/StorySpeaker.gd"

func _ready():
	start_dialog("intro_science")

func _on_interact():
	start_dialog("intro_science_followup")
