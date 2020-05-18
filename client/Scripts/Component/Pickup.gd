extends "res://Scripts/Component/Interactable.gd"

export var item : String
export var clearance_card : int = -1
export var tip : String = ""

func _ready():
	connect("interacted", self, "_on_interact")

func _on_interact():
	if item != "":
		player.add_item(item)
		if len(tip) >= 1:
			give_tip(tip)
	if clearance_card > 0:
		if clearance_card > player.clearance_level:
			player.clearance_level = clearance_card
			give_tip("Unlocked Clearance Level: " + str(clearance_card))
	queue_free()

func give_tip(message):
	var gui = get_tree().root.get_node("World").get_node("GUI")
	gui.display_tip(message)
