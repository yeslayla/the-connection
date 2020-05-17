extends Area2D

export var tip = ""

func _ready():
	connect("body_entered", self, "_on_body_enter")

func _on_body_enter(body):
	if body.has_method("add_interactable"):
		var gui = get_tree().root.get_node("World").get_node("GUI")
		gui.display_tip(tip)
		queue_free()
