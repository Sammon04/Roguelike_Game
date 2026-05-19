class_name ActiveDebuff
extends BaseDebuff

@export var damage_per_tick: float
@export var tick_rate: float
@export var duration: float
@export var max_stack: int

var source: ActiveDebuff
var stacks: int = 1
var _timer: float = 0.0
var _elapsed: float = 0.0
var _enemy: BaseEnemy

func on_applied(enemy: BaseEnemy) -> void:
	_enemy = enemy
	_timer = 0.0
	_elapsed = 0.0

func add_stack() -> void:
	stacks = min(stacks + 1, max_stack)
	_elapsed = 0.0

func tick(delta: float) -> bool:
	_timer += delta
	_elapsed += delta
	if _timer >= tick_rate:
		_timer -= tick_rate
		_enemy.take_damage(damage_per_tick * stacks)
	return _elapsed >= duration
