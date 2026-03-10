extends Node

@export var acceleration: int = 400
@export var rotation_speed: int = 5
@export var friction: int = 400
@export var max_speed: int = 500

@onready var player : CharacterBody2D = get_owner()

func _physics_process(delta) -> void:
	var forward_input = Input.get_action_strength("up") - Input.get_action_strength("down")
	var rotate_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	
	player.rotation += rotate_input * rotation_speed * delta
	
	var forward_vector = player.transform.x
	player.velocity += forward_vector * forward_input * acceleration * delta
	player.velocity = player.velocity.limit_length(max_speed)
	
	if forward_input == 0:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * delta)
		
	player.move_and_slide()
