extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var rot = global_position.angle_to_point(get_global_mouse_position())
	rotation = rot + PI - get_parent().global_rotation

	if Input.is_action_just_pressed("toggle_flashlight"):
		$Light2D.enabled = !$Light2D.enabled
		$Glow.enabled = !$Glow.enabled
