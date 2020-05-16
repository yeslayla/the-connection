extends KinematicBody2D

# Environment variables
export var baseGravity : float = 9.8

# Player movment variables
export var maxMoveVelocity : float = 300
export var moveAcceleration : float = 15
export var moveFriction : float = 45
export var jumpVelocity : float = -150

var moveMotion : float = 0 # Player Input ( <- & -> )
var motion : Vector2 = Vector2(0,0) # Player's current velocity


func _physics_process(delta):
	
	# Gravity
	motion.y += baseGravity
	if is_on_floor():
		motion.y = 0
	
	user_input()
	
	# Apply velocity limits
	moveMotion = clamp(moveMotion, -maxMoveVelocity, maxMoveVelocity)

	# Apply velocity to frame
	motion.x = moveMotion
	animation_manager(moveMotion)
	move_and_slide(motion, Vector2(0,-1))
	

func user_input():
	if(Input.is_action_pressed("ui_left")):
		moveMotion -= moveAcceleration
	if(Input.is_action_pressed("ui_right")):
		moveMotion += moveAcceleration
		
	if(is_on_floor() and Input.is_action_just_pressed("ui_up")):
			motion.y = jumpVelocity
	
	if is_on_floor() and (!Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right")):
		if moveMotion > 0:
			moveMotion = clamp(moveMotion - moveFriction, 0, moveMotion)
		elif moveMotion < 0:
			moveMotion = clamp(moveMotion + moveFriction, moveMotion, 0)
	
func animation_manager(motion : float):

	if moveMotion > 0:
		$AnimationPlayer.playback_speed = abs(motion)/200
		$AnimationPlayer.play("RunRight")
	elif moveMotion < 0:
		$AnimationPlayer.playback_speed = abs(motion)/200
		$AnimationPlayer.play("RunLeft")
	else:
		$AnimationPlayer.playback_speed = 1
		$AnimationPlayer.play("Idle")
