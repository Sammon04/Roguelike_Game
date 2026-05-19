class_name BulletStatUpgrade
extends BulletUpgrade

@export var damage_flat: float = 0.0
@export var damage_mult: float = 1.0
@export var speed_flat: float = 0.0
@export var speed_mult: float = 1.0
@export var lifetime_flat: float = 0.0
@export var lifetime_mult: float = 1.0

func apply_to_bullet(bullet: Bullet) -> void:
	bullet.damage = bullet.damage * damage_mult + damage_flat
	bullet.speed = bullet.speed * speed_mult + speed_flat
	bullet.life_time = bullet.life_time * lifetime_mult + lifetime_flat
