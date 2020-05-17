extends Label

onready var file = 'res://VERSION.txt'

func _ready():
	var f = File.new()
	if f.file_exists(file):
		f.open(file, File.READ)
		if not f.eof_reached():
			text = f.get_line()
		f.close()
	else:
		text = "Custom Build"
