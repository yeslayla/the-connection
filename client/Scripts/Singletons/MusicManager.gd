extends AudioStreamPlayer

var main_player : AudioStreamPlayer
var looping : bool = false

func _ready():
	main_player = self
	bus = "Music"

func play_music(song, loop=true):
	var audio_file = "res://Assets/Music/" + song + ".ogg"
	if load(audio_file):
		var track = load(audio_file)
		looping = loop
		main_player.stream = track
		main_player.play()

func play_stream(track, loop = true):
	looping = loop
	main_player.stream = track
	main_player.play()

func stop_music():
	main_player.stop()

