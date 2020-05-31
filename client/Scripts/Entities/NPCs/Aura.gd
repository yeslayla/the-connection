extends Area2D

var state = 0
var timer : Timer

func _ready():
	$Speaker.speaker_name = "Aura"
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exit")
	$AnimationPlayer.play("Idle")
	$AnimationPlayer.seek(rand_range(0.0,2.0))

func _on_body_enter(body):
	if body.has_method("add_interactable"):
		state = 1
		$Speaker.start_dialog("aura_meeting")
		
func _process(delta):
	if state == 1 and not $Speaker.gui.is_in_dialog():
		$AnimationPlayer.play("Shoot")
		$Speaker.start_dialog("aura_meeting_gun")
		state = 2
	elif state == 2 and not $Speaker.gui.is_in_dialog():
		$"/root/MusicManager".stop()
		if not timer:
			timer = Timer.new()
			add_child(timer)
			timer.connect("timeout", self, "shoot_scene")
			timer.start(0.5)
		

func shoot_scene():
	$AudioStreamPlayer.play()
	$CanvasLayer/Blood.show()
	timer.disconnect("timeout", self, "shoot_scene")
	timer.stop()
	timer.connect("timeout", self, "start_fade")
	timer.start(0.5)
	
func start_fade():
	timer.stop()
	var fader = $CanvasLayer/Fader
	fader.connect("fade_complete", self, "go_to_credits")
	fader.fade(2, false)

func go_to_credits():
	get_tree().change_scene("res://Scenes/Credits.scn")
