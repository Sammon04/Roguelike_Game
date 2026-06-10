class_name StatDebuff
extends BaseDebuff

@export var speed_reduction: float = 0.0
@export var duration: float = 0.0
@export var max_stacks: int

var source: StatDebuff
var debuff_stacks: int = 1
var _elapsed: float = 0.0
var _enemy: BaseEnemy
var _original_speed: float

func on_applied(enemy: BaseEnemy) -> void:
	_enemy = enemy
	_original_speed = enemy.move_speed
	
	activate_effect(_enemy)

func activate_effect(enemy: BaseEnemy) -> void:
	var num_held = source_item.num_held if source_item else 1
	_enemy.move_speed = max(_original_speed - (speed_reduction * debuff_stacks) * num_held, 0.0)

func on_remove(enemy: BaseEnemy) -> void:
	enemy.move_speed = _original_speed

func add_stack() -> void:
	debuff_stacks = min(debuff_stacks + 1, max_stacks)
	_elapsed = 0.0
	activate_effect(_enemy)

func tick(delta: float) -> bool:
	_elapsed += delta
	return _elapsed >= duration
