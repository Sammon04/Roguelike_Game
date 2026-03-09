class_name SpeedBulletStrategy
extends BaseBulletStrategy

@export var speed_increase: float = 50.0

func apply_upgrade(bullet: Bullet):
	bullet.speed += speed_increase
