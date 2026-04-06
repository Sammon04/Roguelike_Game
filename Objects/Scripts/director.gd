extends Node

@onready var spawn_timer : Timer = $SpawnTimer
@onready var wave_timer : Timer = $WaveTimer
@onready var spawn_point : Marker2D = $SpawnPoint
@onready var wave_counter : Label = $"../WaveCounter"
@onready var player = get_tree().get_first_node_in_group("player") as Player

@export var enemy_types : Array[EnemyData]
@export var upgrade_pool : Array[BaseBulletStrategy]
@export var upgrade_scene : PackedScene
@export var current_wave : int = 0
@export var time_between_waves : float = 15
@export var early_wave_delay : float = 3.0
@export var spawn_delay : float = 0.8

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
	print("Starting wave " + str(current_wave) + ", credits available: " + str(wave_credits))
	spawn_timer.wait_time = spawn_delay
	spawn_timer.start()
	spawn_upgrade()
	
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
	
	pick_random_spawn_point()
	enemy.position = spawn_point.global_position
	
	get_tree().current_scene.add_child(enemy)
	
	enemies_spawned += 1
	enemies_alive += 1
	
	print("Enemy spawned")
	print("Enemies spawned: " + str(enemies_spawned))
	print("Enemies alive: " + str(enemies_alive))
	print("Credits remaining: " + str(wave_credits))
	enemy.enemy_died.connect(_on_enemy_died)

func _on_enemy_died():
	enemies_alive = max(enemies_alive - 1, 0)
	
	print("Enemy killed")
	print("Enemies alive: " + str(enemies_alive))
	if enemies_alive == 0 and wave_ended and not wave_shortened:
		print("Ending wave early")
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
	
	print("ending wave")
	spawn_timer.stop()
	wave_timer.start(time_between_waves)

func _on_wave_timer_timeout():
	wave_ended = false
	print("Ending wave normally")
	start_wave()

func pick_random_spawn_point() -> void:
	var screen_size: Vector2 = get_viewport().size
	
	var valid_point: bool = false
	while not valid_point:
		var random_x: float = rng.randf_range(0.0, screen_size.x)
		var random_y: float = rng.randf_range(0.0, screen_size.y)
		
		spawn_point.position = Vector2(random_x, random_y)
		
		if spawn_point.global_position.distance_to(player.global_position) >= 200:
			valid_point = true	

func get_random_upgrade() -> BaseBulletStrategy:
	return upgrade_pool.pick_random()

func spawn_upgrade() -> void:
	var upgrade = upgrade_scene.instantiate()
	var strategy = get_random_upgrade()
	upgrade.bullet_strategy = strategy
	
	pick_random_spawn_point()
	upgrade.position = spawn_point.global_position
	get_tree().current_scene.add_child(upgrade)
	
