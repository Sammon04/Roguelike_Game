extends Node

@onready var camera = $Camera
@onready var player = $"../../Player"

func zoom():
	if Input.is_action_just_released("scroll_up"):
		camera.zoom += Vector2(0.05, 0.05)
	if Input.is_action_just_released("scroll_down"):
		camera.zoom -= Vector2(0.05, 0.05)

func _process(delta: float) -> void:
	camera.global_position = player.global_position
	zoom()
