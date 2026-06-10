class_name PlayerStatItem
extends BaseItem

#@export var accel_flat: float = 0.0
#@export var maxspeed_flat: float = 0.0
#@export var rotatespeed_flat: float = 0.0
#@export var friction_flat: float = 0.0
@export var accel_mult: float = 1.0
@export var maxspeed_mult: float = 1.0
@export var rotatespeed_mult: float = 1.0
@export var friction_mult: float = 1.0

@export var scaling: float = 0.0       

var stack_scaling: float = scaling * num_held                                                             

func on_pickup(player: Player) -> void:
	player.movement.acceleration *= accel_mult + stack_scaling if accel_mult > 1.0 else accel_mult - stack_scaling
	player.movement.max_speed *= maxspeed_mult + stack_scaling if maxspeed_mult > 1.0 else maxspeed_mult - stack_scaling
	player.movement.rotation_speed *= rotatespeed_mult + stack_scaling if rotatespeed_mult > 1.0 else rotatespeed_mult - stack_scaling
	player.movement.friction *= friction_mult + stack_scaling if friction_mult > 1.0 else friction_mult - stack_scaling
