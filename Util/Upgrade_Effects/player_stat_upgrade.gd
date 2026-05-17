class_name PlayerStatUpgrade
extends BaseUpgrade

enum PlayerStat { ACCELERATION, MAX_SPEED, ROTATION_SPEED, FRICTION }

@export var stat: PlayerStat
@export var value: float

func on_pickup(player: Player) -> void:
	match stat:
		PlayerStat.ACCELERATION: player.movement.acceleration += value
		PlayerStat.MAX_SPEED: player.movement.max_speed += value
		PlayerStat.ROTATION_SPEED: player.movement.rotation_speed += value
		PlayerStat.FRICTION: player.movement.friction += value
