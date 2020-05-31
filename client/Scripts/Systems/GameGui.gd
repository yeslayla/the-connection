extends CanvasLayer

signal screen_fade_complete

var in_dialog = false
var tip_timer : Timer
var zone_timer : Timer

const TIP_FADE_RATE = 0.1
const SHOW_TIP_TIME = 3

const ZONE_FADE_RATE = 0.05
const SHOW_ZONE_TIME = 3

func _ready():
	$Dialog.hide()
	$Tip.hide()
	$ZoneLabel.hide()
	$Fader.connect("fade_complete", self, "_on_screen_fade_complete")

func is_in_dialog():
	return in_dialog or $Dialog.is_visible_in_tree()

func current_dialog():
	return $Dialog/Textbox/Body.text

func set_dialog(message, speaker=""):
	$Dialog.show()
	in_dialog = true
	$Dialog/Textbox/Speaker.text = speaker
	$Dialog/Textbox/Body.text = message
	
func finish_dialog():
	in_dialog = false
	$Dialog.hide()

func clear_choices():
	$Dialog/ChoicesPanel.hide()
	for i in range($Dialog/ChoicesPanel/Choices.get_child_count()):
		$Dialog/ChoicesPanel/Choices.get_child(i).queue_free()
	
func add_choice(speaker : Node, choice_id : int, choice_text : String):
	$Dialog/ChoicesPanel.hide()
	var button = Button.new()
	button.text = choice_text
	button.connect("button_down", speaker, "_on_choice", [choice_id])
	$Dialog/ChoicesPanel/Choices.add_child(button)

func show_choices():
	$Dialog/ChoicesPanel.show()
	if $Dialog/ChoicesPanel/Choices.get_child_count() == 0:
		var label = Label.new()
		label.text = "Press SPACE to continue"
		$Dialog/ChoicesPanel/Choices.add_child(label)

func display_tip(tip):
	$Tip.modulate.a = 0
	$Tip.text = tip
	$Tip.show()
	if not tip_timer:
		tip_timer = Timer.new()
		add_child(tip_timer)
	tip_timer.disconnect("timeout", self, "fade_tip_out")
	tip_timer.disconnect("timeout", self, "start_fade_tip_out")
	tip_timer.connect("timeout", self, "fade_tip_in")
	tip_timer.start(TIP_FADE_RATE)
		
func start_fade_tip_out():
	tip_timer.disconnect("timeout", self, "fade_tip_in")
	tip_timer.disconnect("timeout", self, "start_fade_tip_out")
	tip_timer.connect("timeout", self, "fade_tip_out")
	tip_timer.start(TIP_FADE_RATE)
	
func fade_tip_in():
	$Tip.modulate.a = clamp($Tip.modulate.a + 0.1, 0, 1)
	if $Tip.modulate.a == 1:
		tip_timer.disconnect("timeout", self, "fade_tip_out")
		tip_timer.disconnect("timeout", self, "fade_tip_in")
		tip_timer.connect("timeout", self, "start_fade_tip_out")
		tip_timer.start(SHOW_TIP_TIME)
		
func fade_tip_out():
	$Tip.modulate.a = clamp($Tip.modulate.a - 0.1, 0, 1)
	if $Tip.modulate.a == 0:
		tip_timer.stop()

func display_zone(zone):
	$ZoneLabel.modulate.a = 0
	$ZoneLabel.text = "Entering: " + zone
	$ZoneLabel.show()
	if not zone_timer:
		zone_timer = Timer.new()
		add_child(zone_timer)
	zone_timer.disconnect("timeout", self, "fade_zone_out")
	zone_timer.disconnect("timeout", self, "start_fade_zone_out")
	zone_timer.connect("timeout", self, "fade_zone_in")
	zone_timer.start(ZONE_FADE_RATE)
		
func start_fade_zone_out():
	zone_timer.disconnect("timeout", self, "fade_zone_in")
	zone_timer.disconnect("timeout", self, "start_fade_zone_out")
	zone_timer.connect("timeout", self, "fade_zone_out")
	zone_timer.start(ZONE_FADE_RATE)
	
func fade_zone_in():
	$ZoneLabel.modulate.a = clamp($ZoneLabel.modulate.a + 0.1, 0, 1)
	if $ZoneLabel.modulate.a == 1:
		zone_timer.disconnect("timeout", self, "fade_zone_out")
		zone_timer.disconnect("timeout", self, "fade_zone_in")
		zone_timer.connect("timeout", self, "start_fade_zone_out")
		zone_timer.start(SHOW_ZONE_TIME)
		
func fade_zone_out():
	$ZoneLabel.modulate.a = clamp($ZoneLabel.modulate.a - 0.1, 0, 1)
	if $ZoneLabel.modulate.a == 0:
		zone_timer.stop()
		
func fade_screen(seconds = 1, fade_in=true):
	$Fader.fade(seconds, fade_in)
	
func _on_screen_fade_complete():
	emit_signal("screen_fade_complete")
