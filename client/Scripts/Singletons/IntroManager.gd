extends "res://Scripts/Component/Speaker.gd"



var story_reader


var loading_game : bool = false
var audio_clip_player : AudioStreamPlayer
var audio_clip_one = preload("res://Assets/Sfx/intro/loading.wav")
var audio_clip_two = preload("res://Assets/Sfx/intro/processed.wav")

var story_nid = 1
const STORY_DID = 2



func _ready():
	story_reader = $"/root/StoryManager".get_reader()
	
	audio_clip_player = AudioStreamPlayer.new()
	add_child(audio_clip_player)
	
	connect("updated_text", self, "update_text")
	
	speak(story_reader.get_text(STORY_DID, story_nid))

func update_text():
	$CanvasLayer/Control/Label.text = spoken_text

func _process(delta):
	if(Input.is_action_just_pressed("ui_accept") and playing_speech == false):
		if story_reader.has_nid(STORY_DID, story_nid + 1):
			story_nid = story_nid + 1
			speak(story_reader.get_text(STORY_DID, story_nid))
		else:
			$CanvasLayer/Control/Label.text = ""
			if not loading_game:
				start_load_game()
			
func start_load_game():
	loading_game = true
	$"/root/MusicManager".stop_music()
	audio_clip_player.stream = audio_clip_one
	audio_clip_player.connect("finished", self, "_load_next_scene")
	audio_clip_player.play()

func _load_next_scene():
	get_tree().change_scene("res://Scenes/World.scn")
