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
					if not child.is_loaded():
						child.load_zone()
						var gui = get_tree().root.get_node("World").get_node("GUI")
						gui.display_zone(child.display_name)
				else:
					child.unload_zone()
