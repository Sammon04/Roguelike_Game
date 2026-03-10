extends Node

@onready var spawn_timer : Timer = $SpawnTimer
@onready var wave_timer : Timer = $WaveTimer
@onready var spawn_point : Marker2D = $SpawnPoint
@onready var wave_counter : Label = $"../WaveCounter"
@onready var player = get_tree().get_first_node_in_group("player") as Player
var enemy_scene = preload("res://Objects/Scenes/enemy.tscn")

@export var current_wave : int = 0
@export var time_between_waves : float = 15
@export var early_wave_delay : float = 3.0
@export var spawn_delay : float = 0.3
var enemies_to_spawn : int = 0
var enemies_spawned : int = 0
var enemies_alive : int = 0
var ending_wave : bool = false
var rng = RandomNumberGenerator.new()



func _ready():
	rng.randomize()
	start_wave()

func start_wave():
	current_wave += 1
	wave_counter.text = "Wave " + str(current_wave)
	
	enemies_to_spawn = current_wave * 2
	enemies_spawned = 0
	print("Starting wave " + str(current_wave) + ", enemies to spawn: " + str(enemies_to_spawn))
	spawn_timer.wait_time = spawn_delay
	spawn_timer.start()

func end_wave():
	if ending_wave:
		return
		
	ending_wave = true
	
	print("ending wave")
	spawn_timer.stop()
	wave_timer.start(time_between_waves)
	
func end_wave_early():
	if not ending_wave:
		return
	
	if wave_timer.time_left > early_wave_delay:
		wave_timer.start(early_wave_delay)
	
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	pick_random_spawn_point()
	enemy.position = spawn_point.global_position
	
	get_tree().current_scene.add_child(enemy)
	
	enemies_spawned += 1
	enemies_alive += 1
	
	print("Enemy spawned")
	print("Enemies spawned: " + str(enemies_spawned))
	print("Enemies alive: " + str(enemies_alive))
	enemy.enemy_died.connect(_on_enemy_died)
	
func _on_enemy_died():
	enemies_alive = max(enemies_alive - 1, 0)
	
	print("Enemy killed")
	print("Enemies alive: " + str(enemies_alive))
	if enemies_alive == 0 and enemies_spawned == enemies_to_spawn:
		end_wave_early()

func pick_random_spawn_point() -> void:
	var screen_size: Vector2 = get_viewport().size
	
	var valid_point: bool = false
	while not valid_point:
		var random_x: float = rng.randf_range(0.0, screen_size.x)
		var random_y: float = rng.randf_range(0.0, screen_size.y)
		
		spawn_point.position = Vector2(random_x, random_y)
		
		if spawn_point.global_position.distance_to(player.global_position) >= 200:
			valid_point = true
	
func _on_spawn_timer_timeout() -> void:
	if enemies_spawned < enemies_to_spawn:
		spawn_enemy()
	else:
		end_wave()

func _on_wave_timer_timeout():
	ending_wave = false
	start_wave()
