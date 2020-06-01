extends "res://Scripts/Entities/Door.gd"

export var level_index : int = 0

func on_elevator_stop(index):
	if index == level_index:
		unlock()
		open()
	else:
		lock()
