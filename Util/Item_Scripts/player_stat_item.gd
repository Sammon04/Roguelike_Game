class_name PlayerStatItem
extends BaseItem

#@export var accel_flat: float = 0.0
#@export var maxspeed_flat: float = 0.0
#@export var rotatespeed_flat: float = 0.0
#@export var friction_flat: float = 0.0
@export var accel_pcnt: float = 0.0
@export var maxspeed_pcnt: float = 0.0
@export var rotatespeed_pcnt: float = 0.0
@export var friction_pcnt: float = 0.0

#@export var scaling: float = 0.0

#var stack_scaling: float = scaling * num_held                                                             

func on_pickup(player: Player) -> void:
	var plr: PlayerMovement = player.movement
	
	plr.acceleration += plr.base_acceleration * (accel_pcnt * 0.01)
	plr.max_speed += plr.base_max_speed * (maxspeed_pcnt * 0.01)
	plr.rotation_speed += plr.base_rotation_speed * (rotatespeed_pcnt * 0.01)
	plr.friction -= plr.base_friction * (friction_pcnt * 0.01)
