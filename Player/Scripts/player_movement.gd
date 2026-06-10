class_name PlayerMovement
extends Node

@export var base_acceleration: float = 400.0
@export var base_rotation_speed: float = 5.0
@export var base_friction: float = 2.0
@export var base_max_speed: float = 500.0
@export var boost_strength: float = 600.0
@export var max_boost_amount: float = 3

var acceleration: float
var rotation_speed: float
var friction: float
var max_speed: float
var can_boost: bool
var boost_remaining: float

@onready var player : CharacterBody2D = get_owner()
@onready var boost_bar: ProgressBar = $"../BoostMeter"

func _ready() -> void:
	acceleration = base_acceleration
	rotation_speed = base_rotation_speed
	friction = base_friction
	max_speed = base_max_speed
	can_boost = true
	boost_remaining = max_boost_amount
	boost_bar.max_value = max_boost_amount

func _physics_process(delta) -> void:
	var forward_input = Input.get_action_strength("up") - Input.get_action_strength("down")
	var rotate_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	var boost_input = Input.get_action_strength("shift")
	
	player.rotation += rotate_input * rotation_speed * delta
	
	var forward_vector = player.transform.x
	var speed_in_input_direction = player.velocity.dot(forward_vector * forward_input)
	
	if !can_boost:
		boost_input = 0
		
	#boost logic
	if boost_input == 1 && can_boost:
		player.velocity += forward_vector * boost_strength * delta
	
	#movement logic
	if forward_input != 0 and speed_in_input_direction < max_speed + boost_input * boost_strength:
		player.velocity += forward_vector * forward_input * acceleration * delta
	
	#friction
	player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * player.velocity.length() * delta)
	
	if boost_input == 1 && can_boost:
		boost_remaining -= delta
		if boost_remaining <= 0.0:
			boost_remaining = 0.0
			can_boost = false
	if !can_boost:
		boost_remaining += delta
		if boost_remaining >= max_boost_amount:
			boost_remaining = max_boost_amount
			can_boost = true
	elif boost_remaining < max_boost_amount && boost_input == 0:
		boost_remaining += delta
		boost_remaining = min(boost_remaining, max_boost_amount)
	
	player.move_and_slide()
	
	boost_bar.global_position = player.global_position + Vector2(-20, -60)
	boost_bar.value = boost_remaining
