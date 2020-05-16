extends Area2D


var opened = false

export var locked = false
export var security_level = 0
var player_level = -1

func lock():
	locked = true
	$Top/Color.modulate = Color.red
	
func unlock():
	locked = false
	set_color()
	
func set_color():
	match(security_level):
		0:
			$Top/Color.modulate = Color.green
		1:
			$Top/Color.modulate = Color.blue
		2:
			$Top/Color.modulate = Color.yellow
		3:
			$Top/Color.modulate = Color.orange
		4:
			$Top/Color.modulate = Color.red
		5:
			$Top/Color.modulate = Color.purple

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exit")
	if locked:
		lock()
	else:
		unlock()

func _on_body_enter(body):
	if body.has_method("add_interactable"):
		if body.clearance_level >= security_level and not locked:
			open()
		
func _on_body_exit(body):
	if body.has_method("remove_interactable"):
		close()

func open():
	if not opened:
		$AnimationPlayer.play("Open")
		$AudioStreamPlayer2D.play()
		$StaticBody2D.collision_layer = 0
		$StaticBody2D.collision_mask = 0
		opened = true

func close():
	if opened:
		$AnimationPlayer.play("Close")
		$AudioStreamPlayer2D.play()
		$StaticBody2D.collision_layer = 1
		$StaticBody2D.collision_mask = 1
		opened = false
