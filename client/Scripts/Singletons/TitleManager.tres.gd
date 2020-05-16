extends Node

func _ready():
	$"/root/MusicManager".play_music("Dystopian/Dystopian")
	$Environment/AnimationPlayer.playback_speed = 0.25
	$Environment/AnimationPlayer.play("Floating")
