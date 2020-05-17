extends Node2D

export var display_name = "Untitled"
export var load_on_start = false
export var music : AudioStream

var loaded = false

func is_loaded():
	return loaded

func _ready():
	if load_on_start:
		load_zone()
	else:
		unload_zone()

func load_zone():
	if $"/root/MusicManager".stream != music:
		$"/root/MusicManager".play_stream(music)
	show()
	loaded = true
	
func unload_zone():
	hide()
	loaded = false

