extends KinematicBody2D

export var clearance_level = 0

# Environment variables
var baseGravity : float = 9.8

# Player movment variables
var maxMoveVelocity : float = 150
var moveAcceleration : float = 100
var moveFriction : float = 65
var jumpVelocity : float = -150
var jumped = false

var moveMotion : float = 0 # Player Input ( <- & -> )
var motion : Vector2 = Vector2(0,0) # Player's current velocity

var gui # Node representing GUI object

var interactables = [] # Objects in range to interact with
var items = [] # Items in player inventory
var equiped = null # Currently equiped item

var saved_pos
func _ready():
	saved_pos = position

#==================
# Helper Functions
#==================
func is_movement_locked():
	if gui and gui.is_in_dialog():
		return true
	return false
	
func check_for_nodes():
	if not gui:
		gui = get_node("/root/World/GUI")

#==================
# Death management
#==================
func handle_death():
	print_debug("Player death not implemented!")
	gui.fade_screen(0.25, false)
	gui.connect("screen_fade_complete", self, "death_fade_complete")

func death_fade_complete():
	position = saved_pos
	gui.fade_screen(1, true)
	gui.disconnect("screen_fade_complete", self, "death_fade_complete")

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
	check_for_nodes()
	
	jumped = false
	
	# Gravity
	if is_on_floor():
		motion.y = 0
	else:
		motion.y += baseGravity

	# Manage movement input
	if not is_movement_locked():
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

	if not test_move(transform, Vector2(0,1)):
			$AnimationPlayer.play("InAir")
	elif jumped:
		if $AnimationPlayer.current_animation != "Jump":
			$AnimationPlayer.play("Jump")
	elif moveMotion > 0:
		$AnimationPlayer.playback_speed = abs(motion)/100
		if $AnimationPlayer.current_animation != "RunRight":
			$AnimationPlayer.play("RunRight")
	elif moveMotion < 0:
		$AnimationPlayer.playback_speed = abs(motion)/100
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
		var test_pos = Vector2(position.x,position.y+6)
		if not test_move(Transform2D(0,test_pos), Vector2(0,1)):
			position.y = position.y + 2
			return
	
	# Jumping
	if(test_move(transform, Vector2(0,1)) and Input.is_action_just_pressed("ui_up")):
			jumped = true

	# Move left and right <- & ->
	# - - - - - - - - - - - - - - -
	var movementModifier = 1

	if not test_move(transform, Vector2(0,1)):
		movementModifier = 0.5

	# Movement input
	if(Input.is_action_pressed("ui_left")):
		moveMotion = -moveAcceleration * movementModifier
	if(Input.is_action_pressed("ui_right")):
		moveMotion = moveAcceleration * movementModifier
	if is_on_floor() and (!Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right")):
		if moveMotion > 0:
			moveMotion = clamp(moveMotion - moveFriction, 0, moveMotion)
		elif moveMotion < 0:
			moveMotion = clamp(moveMotion + moveFriction, moveMotion, 0)
