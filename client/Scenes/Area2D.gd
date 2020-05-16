extends "res://Scripts/Component/Interactable.gd"

func _ready():
	connect("interacted", self, "_on_interact")

func _on_interact():
	$Speaker.start_dialog("intro_transportship")
