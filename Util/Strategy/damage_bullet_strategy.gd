class_name DamageBulletStrategy
extends BaseBulletStrategy

@export var damage_increase: float = 5.0

func apply_upgrade(bullet: Bullet):
	bullet.damage += damage_increase
