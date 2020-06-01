extends Node2D

signal elevator_stopped

export(Array, Vector2) var relative_positions = [Vector2(0,0)]
export(Array, String) var labels = ["Default"]
export(Array, NodePath) var doors = []
export var current_pos : int = 0

var moving : bool = false

var gui
var motion
var intial_pos : Vector2
export var elevator_speed = 25

func _ready():
	motion = Vector2.ZERO
	intial_pos = global_position

func _on_interact():
	if not moving:
		if not gui:
			gui = get_node("/root/World/GUI")
		gui.open_elevator_menu(self)

func _on_choice(index):
	start_moving(index)
	gui.close_elevator_menu()
	
func start_moving(index):
	if current_pos != index:
		moving = true
		current_pos = index
		
		# Close all doors while in transit
		for door_path in doors:
			var door = get_node(door_path)
			door.close()
			door.lock()
		return true
	return false
		
func stop_moving():
	emit_signal("elevator_stopped")
	moving = false
	# Alert doors of updated elevator state
	for door_path in doors:
		get_node(door_path).on_elevator_stop(current_pos)

func _physics_process(delta):
	if moving:
		# Move towards elevator stop
		var target_pos = intial_pos + relative_positions[current_pos]
		var angle = get_angle_to(target_pos)
		var velocity = Vector2(cos(angle),sin(angle))
		global_position += velocity * elevator_speed * delta

		# Stop when elevator is at destination
		if global_position.distance_to(target_pos) < 0.25:
			global_position = target_pos
			stop_moving()
