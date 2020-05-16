extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_dialog(message, speaker=""):
	$Dialog.show()
	$Dialog/Textbox/Speaker.text = speaker
	$Dialog/Textbox/Body.text = message
	
func finish_dialog():
	$Dialog.hide()

func clear_choices():
	$Dialog/Choices.hide()
	for i in range($Dialog/Choices.get_child_count()):
		$Dialog/Choices.get_child(i).queue_free()
	
func add_choice(speaker : Node, choice_id : int, choice_text : String):
	var button = Button.new()
	button.text = choice_text
	button.connect("button_down", speaker, "_on_choice", [choice_id])
	$Dialog/Choices.add_child(button)

func show_choices():
	$Dialog/Choices.show()
