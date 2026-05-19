class_name PassiveDebuff
extends BaseDebuff

@export var speed_reduction: float = 0.0
@export var duration: float = 0.0

var _elapsed: float = 0.0

func on_applied(enemy: BaseEnemy) -> void:
	enemy.enemy_speed = max(enemy.enemy_speed - speed_reduction, 0.0)

func on_remove(enemy: BaseEnemy) -> void:
	enemy.enemy_speed += speed_reduction

func tick(delta: float) -> bool:
	_elapsed += delta
	return _elapsed >= duration
