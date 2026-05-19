class_name PlayerStatUpgrade
extends BaseUpgrade

enum PlayerStat { ACCELERATION, MAX_SPEED, ROTATION_SPEED, FRICTION }

@export var accel_flat: float = 0.0
@export var accel_mult: float = 1.0
@export var maxspeed_flat: float = 0.0
@export var maxspeed_mult: float = 1.0
@export var rotatespeed_flat: float = 0.0
@export var rotatespeed_mult: float = 1.0
@export var friction_flat: float = 0.0
@export var friction_mult: float = 1.0

func on_pickup(player: Player) -> void:
	player.movement.acceleration = player.movement.acceleration * accel_mult + accel_flat
	player.movement.max_speed = player.movement.max_speed * maxspeed_mult + maxspeed_flat
	player.movement.rotation_speed = player.movement.rotation_speed * rotatespeed_mult + rotatespeed_flat
	player.movement.friction = player.movement.friction * friction_mult + friction_flat
