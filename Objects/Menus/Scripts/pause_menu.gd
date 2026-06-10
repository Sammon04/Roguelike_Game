class_name PauseMenu
extends Node

var is_paused: bool = false

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		is_paused = !is_paused
		get_tree().paused = is_paused
