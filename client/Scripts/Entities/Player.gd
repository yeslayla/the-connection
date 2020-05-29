extends KinematicBody2D

export var clearance_level = 0

# Environment variables
var baseGravity : float = 9.8

# Player movment variables
var maxMoveVelocity : float = 150
var moveAcceleration : float = 125
var moveFriction : float = 65
var jumpVelocity : float = -150
var jumped = false

var moveMotion : float = 0 # Player Input ( <- & -> )
var motion : Vector2 = Vector2(0,0) # Player's current velocity

var gui # Node representing GUI object

var interactables = [] # Objects in range to interact with
var items = [] # Items in player inventory
var equiped = null # Currently equiped item

#==================
# Inventory System
#==================
func add_item(item):
	items.append(item)
	equip_item(item)

func equip_item(item):
	var node = get_node_or_null("Sprite/Torso/RightArm/RightForearm/LeftHand/Node2D/" + item)
	if node:
		equiped = item
		node.show()
	else:
		print("Tried to equip: " + item + " but item was missing!")

#==============
# Interactions
#==============
func add_interactable(interactable):
	interactables.append(interactable)
func remove_interactable(interactable):
	var loc = interactables.find(interactable)
	if loc >= 0:
		interactables.remove(loc)
func interact():
	interactables[0].interact()

#==========
# Game Loop
#===========
func _physics_process(delta):
	jumped = false
	
	# Gravity
	motion.y += baseGravity
	
	if not gui:
		gui = get_node("/root/World/GUI")
	elif not gui.is_in_dialog():
		user_input()
		if jumped:
			motion.y = jumpVelocity
	else:
		moveMotion = 0
	
	# Apply velocity limits
	moveMotion = clamp(moveMotion, -maxMoveVelocity, maxMoveVelocity)
	
	

	# Apply velocity to frame
	motion.x = moveMotion
	animation_manager(moveMotion)
	move_and_slide(motion, Vector2(0,-1))

#===================
# Animation Manager
#===================
#
# Changes animation basd on current
# conditions
func animation_manager(motion : float):

	if not is_on_floor():
			$AnimationPlayer.play("InAir")
	elif jumped:
		if $AnimationPlayer.current_animation != "Jump":
			$AnimationPlayer.play("Jump")
	elif moveMotion > 0:
		$AnimationPlayer.playback_speed = abs(motion)/200
		if $AnimationPlayer.current_animation != "RunRight":
			$AnimationPlayer.play("RunRight")
	elif moveMotion < 0:
		$AnimationPlayer.playback_speed = abs(motion)/200
		if $AnimationPlayer.current_animation != "RunLeft":
			$AnimationPlayer.play("RunLeft")
	else:
		$AnimationPlayer.playback_speed = 1
		$AnimationPlayer.play("Idle")

#============
# User Input
#============
func user_input():
	# Interactions
	if Input.is_action_just_pressed("interact") and len(interactables) > 0 and not gui.is_in_dialog():
		interact()
	
	# Move down platforms
	if is_on_floor() and Input.is_action_just_pressed("ui_up") and Input.is_action_pressed("ui_down"):
		var test_pos = Vector2(position.x,position.y+5)
		if not test_move(Transform2D(0,test_pos), Vector2(0,1)):
			position.y = position.y + 1
			return
	
	# Jumping
	if(is_on_floor() and Input.is_action_just_pressed("ui_up")):
			jumped = true
	
	# Move left and right <- & ->
	if(Input.is_action_pressed("ui_left")):
		moveMotion = -moveAcceleration
	if(Input.is_action_pressed("ui_right")):
		moveMotion = moveAcceleration
	if is_on_floor() and (!Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right")):
		if moveMotion > 0:
			moveMotion = clamp(moveMotion - moveFriction, 0, moveMotion)
		elif moveMotion < 0:
			moveMotion = clamp(moveMotion + moveFriction, moveMotion, 0)
