extends "res://Scripts/Component/Interactable.gd"

export var dialog_name : String  = "unconfigured"

func _ready():
	connect("interacted", self, "_on_interact")

func _on_interact():
	$Speaker.start_dialog(dialog_name)
