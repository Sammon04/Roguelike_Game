class_name BulletDebuffUpgrade
extends BulletUpgrade

@export var debuffs: Array[BaseDebuff] = []

func apply_to_bullet(bullet: Bullet) -> void:
	for debuff in debuffs:
		bullet.on_hit_debuffs.append(debuff)
