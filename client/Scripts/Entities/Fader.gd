extends ColorRect

signal fade_complete

export var fade_on_start : bool = false
export var start_with_fade_in : bool = true
export var fade_time : float = 1

func _ready():

	if fade_on_start:
		# Fade on start, if enabled
		fade(fade_time, start_with_fade_in)
	else:
		# Retain visibility
		if self.visible:
			modulate.a = 1
		else:
			modulate.a = 0
 
	self.show()

var timePassed = 0 #Current amount of time spend displaying te
const CHECK_LENGTH = 0.05 #Interval to check for updates
var timeNeeded = 0 #Time it takes to fade out
var fadeTimer #Timer object

var fading_in = false

func fade(seconds, fade_in = false):
	fading_in = fade_in
	
	# Set timer values
	timeNeeded = seconds
	timePassed = 0

	# Create timer if needed
	if(!fadeTimer):
		fadeTimer = Timer.new()
		add_child(fadeTimer)
		fadeTimer.connect("timeout", self, "on_fade_timeout")
		
	# Start fader with tick speed of `CHECK_LENGTH`
	fadeTimer.start(CHECK_LENGTH)

func on_fade_timeout():
	timePassed += CHECK_LENGTH
	
	# Set modulate
	if fading_in:
		modulate.a = 1 - abs(timePassed/timeNeeded)
	else:
		modulate.a = abs(timePassed/timeNeeded)

	if(timePassed >= timeNeeded):
		fadeTimer.stop()
		emit_signal("fade_complete")
	else:
		fadeTimer.start(CHECK_LENGTH)
