extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exit")
	get_parent().get_node("Light2D").enabled = false

func _on_body_enter(body):
	if body.has_method("add_interactable"):
		get_parent().get_node("Light2D").enabled = true
		
func _on_body_exit(body):
	if body.has_method("remove_interactable"):
		get_parent().get_node("Light2D").enabled = false
