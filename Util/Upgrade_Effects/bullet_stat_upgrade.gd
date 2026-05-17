class_name BulletStatUpgrade
extends BulletUpgrade

enum BulletStat { DAMAGE, SPEED, LIFETIME}

@export var stat: BulletStat
@export var value: float

func apply_to_bullet(bullet: Bullet) -> void:
	match stat:
		BulletStat.DAMAGE: bullet.damage += value
		BulletStat.SPEED: bullet.speed += value
		BulletStat.LIFETIME: bullet.life_time += value
