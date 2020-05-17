extends "res://Scripts/Component/Interactable.gd"

export var item : String
export var tip : String = ""

func _ready():
	connect("interacted", self, "_on_interact")

func _on_interact():
	player.add_item(item)
	if len(tip) >= 1:
		var gui = get_tree().root.get_node("World").get_node("GUI")
		gui.display_tip(tip)
	queue_free()
