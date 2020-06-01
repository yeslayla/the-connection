extends "res://Scripts/Component/Interactable.gd"

func _ready():
	connect("interacted", get_parent(), "_on_interact")
