class_name GunStatUpgrade
extends BaseUpgrade

@export var rof_flat: float = 0.0
@export var rof_mult: float = 1.0
@export var bulletnum_flat: float = 0.0
@export var bulletnum_mult: float = 1.0
@export var spread_flat: float = 0.0
@export var spread_mult: float = 1.0

func on_pickup(player: Player) -> void:
	player.gun.fire_rate = player.gun.fire_rate * rof_mult + rof_flat
	player.gun.num_bullets = player.gun.num_bullets * bulletnum_mult + bulletnum_flat
	player.gun.spread = player.gun.spread * spread_mult + spread_flat
