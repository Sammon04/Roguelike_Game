class_name CompoundItem
extends BaseItem

@export var bullet_effects: BulletStatItem
@export var player_effects: PlayerStatItem
@export var gun_effects: GunStatItem

func on_pickup(player: Player) -> void:
	if bullet_effects:
		player.bullet_stat_items.append(bullet_effects)
	if gun_effects:
		gun_effects.on_pickup(player)
	if player_effects:
		player_effects.on_pickup(player)
