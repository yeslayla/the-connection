extends Control

const SCROLL_SPEED = 25

func _ready():
	$"/root/MusicManager".play_music("Dystopian/The Story Continues")

func _process(delta):
	$Scolling.rect_position.y = $Scolling.rect_position.y - delta * SCROLL_SPEED
	
	if abs($Scolling.rect_position.y) > $Scolling.rect_size.y + 100:
		get_tree().change_scene("res://Scenes/Title.scn")
