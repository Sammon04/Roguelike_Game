class_name BulletDebuffItem
extends BulletItem

@export var debuff: BaseDebuff

#Unused
func apply_to_bullet(bullet: Bullet) -> void:
	bullet.on_hit_debuffs.append(debuff)
