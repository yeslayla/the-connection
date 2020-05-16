extends Area2D

export var load_zone : String = ""

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body):
	if body.has_method("user_input"):
		var parent = get_parent()
		for i in range(0, parent.get_child_count()):
			var child = parent.get_child(i)
			if child.has_method("load_zone"):
				if child.name == load_zone + "Zone":
					child.load_zone()
				else:
					child.unload_zone()
