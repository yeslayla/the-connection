extends Node

export var locale = "en"

const Story_Reader_Class = preload("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
const default_story = preload("res://Assets/Stories/dev_story.tres")
var story_reader = Story_Reader_Class.new()
var loaded : bool = false


func get_reader():
	if not loaded:
		story_reader.read(default_story)
		loaded = true
	return story_reader

func set_locale():
	story_reader.read(load("res://Assets/Stories/" + locale + "_story.tres"))
	loaded = true
