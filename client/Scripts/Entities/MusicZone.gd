extends Area2D

export var music : AudioStream

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body):
	if body.has_method("user_input"):
		if $"/root/MusicManager".stream != music:
			$"/root/MusicManager".play_stream(music)
