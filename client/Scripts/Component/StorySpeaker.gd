extends "res://Scripts/Component/Speaker.gd"

signal dialog_exited

const Story_Reader_Class = preload("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
const story_file = preload("res://Assets/Stories/english_story.tres")
var story_reader = Story_Reader_Class.new()

var gui

var nid : int = 1
var did : int
var choices : int = 1
var selected_choice : int = -1
export var speaker_name = ""
var final_display_message = ""

func _ready():
	story_reader.read(story_file)
	
	connect("updated_text", self, "_on_text_update")
	connect("finished_text", self, "_on_finish_text")

func _on_finish_text():
	gui.show_choices()

func _on_text_update():
	gui.set_dialog(spoken_text, speaker_name)

func start_dialog(record : String):
	start_dialog_did(story_reader.get_did_via_record_name(record))

func intialize_dialog():
	if not gui:
		gui = get_node("/root/World/GUI")


func start_dialog_did(dialog_id : int):
	intialize_dialog()
	if not gui.is_in_dialog():
		nid = 1
		did = dialog_id
		process_message(story_reader.get_text(did, nid))
	
func has_next_node():
	return story_reader.has_slot(did, nid, 0)


	
func process_message(message):
	gui.clear_choices()
	selected_choice = -1
	choices = message.count("<choice>")
	if choices > 0:
		var i = 0
		var last = ""
		while i < choices:
			var start = message.find("<choice>")
			var end = message.find("</choice>")
			if start != -1 and end != -1:
				var choice_text = message.substr( start+len("<choice>"), end-start-len("</choice>")+1 )
				if choice_text == last:
					printerr("Choice in did " + str(did) + ", nid " + str(nid) + " not closed!")
					break
				else:
					gui.add_choice(self, i, choice_text)
				message = message.replace("<choice>"+choice_text+"</choice>", "")
			i = i + 1

	speak(message)
	final_display_message = message
	
func _on_choice(decision):
	move_dialog_forward(decision)
	
func move_dialog_forward(decision = 0):
	if has_next_node():
		nid = story_reader.get_nid_from_slot(did, nid, decision)
		process_message(story_reader.get_text(did, nid))
	else:
		emit_signal("dialog_exited")
		gui.finish_dialog()
	
func _process(delta):
	if(Input.is_action_just_pressed("ui_accept") and choices == 0 and final_display_message == gui.current_dialog()):
		move_dialog_forward(0)
