extends Area2D

signal interacted

func _ready():
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exit")

func _on_body_enter(body):
	if body.has_method("add_interactable"):
		body.add_interactable(self)
		
func _on_body_exit(body):
	if body.has_method("remove_interactable"):
		body.remove_interactable(self)

func interact():
	emit_signal("interacted")
