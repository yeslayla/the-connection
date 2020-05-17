extends Control

const SCROLL_SPEED = 25

var scroll_timer : Timer
const SCROLL_TIP_DELAY = 5
const SCROLL_FADE_RATE = 0.05
const SCROLL_SHOW_RATE = 5

func _ready():
	$"/root/MusicManager".play_music("Dystopian/The Story Continues", false)
	if not scroll_timer:
		scroll_timer = Timer.new()
		add_child(scroll_timer)
	$Tip.modulate.a = 0
	scroll_timer.connect("timeout", self, "display_tip")
	scroll_timer.start(SCROLL_TIP_DELAY)
	set_completed()

func _process(delta):
	
	if Input.is_action_pressed("ui_accept"):
		$Scolling.rect_position.y = $Scolling.rect_position.y - delta * SCROLL_SPEED * 10
	else:
		$Scolling.rect_position.y = $Scolling.rect_position.y - delta * SCROLL_SPEED
	if abs($Scolling.rect_position.y) > $Scolling.rect_size.y + 100:
		get_tree().change_scene("res://Scenes/Title.scn")

func display_tip():
	$Tip.modulate.a = 0
	$Tip.text = "Press SPACE to speed up."
	$Tip.show()
	scroll_timer.disconnect("timeout", self, "display_tip")
	scroll_timer.disconnect("timeout", self, "fade_tip_out")
	scroll_timer.disconnect("timeout", self, "start_fade_tip_out")
	scroll_timer.connect("timeout", self, "fade_tip_in")
	scroll_timer.start(SCROLL_FADE_RATE)
		
func start_fade_tip_out():
	scroll_timer.disconnect("timeout", self, "display_tip")
	scroll_timer.disconnect("timeout", self, "fade_tip_in")
	scroll_timer.disconnect("timeout", self, "start_fade_tip_out")
	scroll_timer.connect("timeout", self, "fade_tip_out")
	scroll_timer.start(SCROLL_FADE_RATE)
	
func fade_tip_in():
	$Tip.modulate.a = clamp($Tip.modulate.a + 0.1, 0, 1)
	if $Tip.modulate.a == 1:
		scroll_timer.disconnect("timeout", self, "display_tip")
		scroll_timer.disconnect("timeout", self, "fade_tip_out")
		scroll_timer.disconnect("timeout", self, "fade_tip_in")
		scroll_timer.connect("timeout", self, "start_fade_tip_out")
		scroll_timer.start(SCROLL_SHOW_RATE)
		
func fade_tip_out():
	$Tip.modulate.a = clamp($Tip.modulate.a - 0.1, 0, 1)
	if $Tip.modulate.a == 0:
		scroll_timer.stop()

func set_completed():
	var file = File.new()
	file.open("user://progress.json", File.WRITE)
	file.store_string(to_json({"completed":"true"}))
	file.close()
