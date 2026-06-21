class_name BulletStatItem
extends BulletItem

#@export var damage_flat: float = 0.0
#@export var speed_flat: float = 0.0
#@export var lifetime_flat: float = 0.0
@export var damage_mult: float = 1.0
@export var speed_mult: float = 1.0
@export var lifetime_mult: float = 1.0
@export var pierce_flat: int = 0

#@export var flat_scaling: float = 0.0
@export var scaling: float = 0.0
var stack_scale: float

func apply_to_bullet(bullet: Bullet):
	stack_scale = scaling * num_held
	
	if damage_mult != 1.0:
		bullet.damage *= damage_mult + stack_scale if damage_mult > 1.0 else damage_mult - stack_scale
	if speed_mult != 1.0:
		bullet.speed *= speed_mult + stack_scale if speed_mult > 1.0 else speed_mult - stack_scale
	if lifetime_mult != 1.0:
		bullet.life_time *= lifetime_mult + stack_scale if lifetime_mult > 1.0 else lifetime_mult - stack_scale
	bullet.pierce += pierce_flat + stack_scale
