extends Area2D

var player_node

func _ready():
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exit")
	set_process(false)

func _on_body_enter(body):
	if body.has_method("user_input"):
		player_node = body
		set_process(true)
			

func _on_body_exit(body):
	if body.has_method("user_input"):
		body.floor_speed = Vector2.ZERO
		set_process(false)
			
func _process(delta):
	if get_parent().motion.y > 0:
		player_node.floor_speed = get_parent().motion
	else:
		player_node.floor_speed = Vector2.ZERO
