extends CanvasLayer

func is_in_dialog():
	return in_dialog or $Dialog.is_visible_in_tree()

var in_dialog = false

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
	$Dialog/Choices.hide()
	for i in range($Dialog/Choices.get_child_count()):
		$Dialog/Choices.get_child(i).queue_free()
	
func add_choice(speaker : Node, choice_id : int, choice_text : String):
	$Dialog/Choices.hide()
	var button = Button.new()
	button.text = choice_text
	button.connect("button_down", speaker, "_on_choice", [choice_id])
	$Dialog/Choices.add_child(button)

func show_choices():
	$Dialog/Choices.show()
