class_name Director
extends Node

@onready var spawn_timer : Timer = $SpawnTimer
@onready var wave_timer : Timer = $WaveTimer
@onready var wave_counter : Label = $"../WaveCounter"
@onready var item_spawner: ItemSpawner = $ItemSpawner
@onready var spawn_region: SpawnRegion = $"../SpawnRegion"
@onready var player = get_tree().get_first_node_in_group("player") as Player

@export var enemy_types : Array[EnemyData]
@export var time_between_waves : float = 15
@export var early_wave_delay : float = 3.0
@export var spawn_delay : float = 0.8

var current_wave : int = 0
var wave_credits : int = 0
var enemies_spawned : int = 0
var enemies_alive : int = 0
var spawning_enemies : bool = false
var wave_ended : bool = false
var wave_shortened : bool = false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	start_wave()

func start_wave():
	wave_ended = false
	wave_shortened = false
	current_wave += 1
	wave_counter.text = "Wave " + str(current_wave)
	
	wave_credits = 40 + current_wave * 10
	spawning_enemies = true
	enemies_spawned = 0
	spawn_timer.wait_time = spawn_delay
	spawn_timer.start()
	item_spawner.spawn_at(pick_random_spawn_point())
	
func _on_spawn_timer_timeout() -> void:
	if spawning_enemies:
		spawn_enemy()

func spawn_enemy():
	var options = enemy_types.filter(func(e): return e.credits <= wave_credits)
	
	if options.is_empty():
		spawning_enemies = false
		end_wave()
		return
	
	var choice = options.pick_random()
	var enemy = choice.scene.instantiate()
	wave_credits -= choice.credits
	
	enemy.position = spawn_region.get_random_point(player)
	
	get_tree().current_scene.add_child(enemy)
	
	enemies_spawned += 1
	enemies_alive += 1
	
	enemy.enemy_died.connect(_on_enemy_died)

func _on_enemy_died():
	enemies_alive = max(enemies_alive - 1, 0)
	
	if enemies_alive == 0 and wave_ended and not wave_shortened:
		shorten_wave_timer()

func shorten_wave_timer():
	if wave_shortened:
		return
	wave_shortened = true
	if wave_timer.time_left > early_wave_delay:
		wave_timer.start(early_wave_delay)

func end_wave():
	if wave_ended:
		return
	
	wave_ended = true
	
	spawn_timer.stop()
	wave_timer.start(time_between_waves)

func _on_wave_timer_timeout():
	#wave_ended = false
	start_wave()

func pick_random_spawn_point() -> Vector2:
	var screen_size: Vector2 = get_viewport().size
	var attempts = 0
	while attempts < 50:
		attempts += 1
		var pos = Vector2(rng.randf_range(0, screen_size.x), rng.randf_range(0, screen_size.y))
		if pos.distance_to(player.global_position) >= 200:
			return pos
	return Vector2.ZERO
	
