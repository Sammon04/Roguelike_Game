class_name DamageOverTime
extends BaseDebuff

@export var damage_per_tick: float
@export var tick_rate: float
@export var duration: float
@export var max_stacks: int

var source_debuff: DamageOverTime
var debuff_stacks: int = 1
var _timer: float = 0.0
var _elapsed: float = 0.0
var _enemy: BaseEnemy

func on_applied(enemy: BaseEnemy) -> void:
	_enemy = enemy
	_timer = 0.0
	_elapsed = 0.0
	
	var num_held = source_item.num_held if source_item else 1
	damage_per_tick *= num_held

func add_stack() -> void:
	debuff_stacks = min(debuff_stacks + 1, max_stacks)
	_elapsed = 0.0

func tick(delta: float) -> bool:
	_timer += delta
	_elapsed += delta
	if _timer >= tick_rate:
		_timer -= tick_rate
		_enemy.take_damage(damage_per_tick * debuff_stacks)
	return _elapsed >= duration
