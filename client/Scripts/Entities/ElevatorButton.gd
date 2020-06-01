extends "res://Scripts/Component/Interactable.gd"

export(NodePath) var elevator
export var call_to_index : int = 0

var elevator_node

func _ready():
	elevator_node = get_node(elevator)
	connect("interacted", self, "_on_interact")
	$AnimationPlayer.play("Done")

func _on_interact():
	if elevator_node.start_moving(call_to_index):
		elevator_node.connect("elevator_stopped", self, "_on_finish")
		$AnimationPlayer.play("Waiting")
	
func _on_finish():
	elevator_node.disconnect("elevator_stopped", self, "_on_finish")
	$AnimationPlayer.play("Done")
