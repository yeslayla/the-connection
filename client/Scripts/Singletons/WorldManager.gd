extends Node

var audio_player : AudioStreamPlayer
var gui_manager

#$"/root/MusicManager".play_music("Dystopian/The Protagonist")

func _ready():
	gui_manager = $GUI
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	$Fader/ColorRect.show()
	play_sound(preload("res://Assets/Sfx/intro/processed.wav"))

func play_sound(audio_stream):
	audio_player.stream = audio_stream
	audio_player.play()
