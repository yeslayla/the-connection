extends Node2D

export var load_on_start = false
export var music : AudioStream

func _ready():
	if load_on_start:
		load_zone()
	else:
		unload_zone()

func load_zone():
	if $"/root/MusicManager".stream != music:
		$"/root/MusicManager".play_stream(music)
	show()
	
func unload_zone():
	hide()

