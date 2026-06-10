class_name GunStatItem
extends BaseItem

#@export var rof_flat: float = 0.0
#@export var spread_flat: float = 0.0
@export var rof_mult: float = 1.0
@export var bulletnum_flat: int = 0
@export var spread_mult: float = 1.0

@export var scaling: float = 0.0

var stack_scaling: float = scaling * num_held

func on_pickup(player: Player) -> void:
	player.gun.fire_rate *= rof_mult + stack_scaling if rof_mult > 1.0 else rof_mult - stack_scaling
	player.gun.num_bullets += bulletnum_flat
	player.gun.spread *= spread_mult + stack_scaling if spread_mult > 1.0 else spread_mult - stack_scaling
