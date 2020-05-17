extends Node

var audio_player : AudioStreamPlayer
var audio_clip = preload("res://Assets/Sfx/button_press.wav")


func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = audio_clip
	
	$StartButton.connect("button_down", self, "_on_button_press", ["start"])
	$QuitButton.connect("button_down", self, "_on_button_press", ["quit"])
	$CreditsButton.connect("button_down", self, "_on_button_press", ["credits"])
	$OptionsButton.connect("button_down", self, "_on_button_press", ["options"])
	$BugButton.connect("button_down", self, "_on_button_press", ["bug"])
	check_completion()


func _on_button_press(button):
	audio_player.play()
	match(button):
		"start":
			get_tree().change_scene("res://Scenes/Intro.scn")
		"quit":
			get_tree().quit(0)
		"credits":
			get_parent().get_parent().get_node("CreditsDialog").popup_centered()
		"options":
			get_parent().get_parent().get_node("OptionsDialog").popup_centered()
		"bug":
			OS.shell_open("https://github.com/josephbmanley/the-connection/issues/new?labels=bug&template=1_bug_report.md")
		"feedback":
			OS.shell_open("https://cloudsumu.com/r/confeedback")

func check_completion():
	var file = File.new()
	if file.file_exists("user://progress.json"):
		file.open("user://progress.json", File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			if "completed" in data:
				if data["completed"] == "true":
					var feed_back_button = Button.new()
					feed_back_button.text = "Give Feedback"
					feed_back_button.connect("button_down", self, "_on_button_press", ["feedback"])
					add_child(feed_back_button)
					move_child(feed_back_button, 3)
