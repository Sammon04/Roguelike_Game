extends Node

@onready var camera: Camera2D = $Camera
@onready var player: Player = $"../../Player"

var max_zoom: float = 0.5

func zoom():
	if Input.is_action_just_released("scroll_up"):
		if camera.zoom < Vector2(1 + max_zoom, 1 + max_zoom):
			camera.zoom += Vector2(0.05, 0.05)
	if Input.is_action_just_released("scroll_down"):
		if camera.zoom > Vector2(1 - max_zoom, 1 - max_zoom):
			camera.zoom -= Vector2(0.05, 0.05)

func _process(_delta: float) -> void:
	camera.global_position = player.global_position
	zoom()
