class_name CompoundUpgrade
extends BaseUpgrade

@export var bullet_effects: BulletStatUpgrade
@export var player_effects: PlayerStatUpgrade
@export var gun_effects: GunStatUpgrade

func on_pickup(player: Player) -> void:
	if bullet_effects:
		player.bullet_stat_upgrades.append(bullet_effects)
	if gun_effects:
		gun_effects.on_pickup(player)
	if player_effects:
		player_effects.on_pickup(player)
