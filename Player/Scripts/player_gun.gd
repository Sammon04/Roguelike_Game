extends Node2D

@onready var shoot_point : Marker2D = $ShootPoint
@onready var shoot_sound : AudioStreamPlayer = $ShootSound
@onready var player : Player = $"../../../Player"
var bullet_scene : PackedScene = preload("res://Objects/Scenes/bullet.tscn")

@export var fire_rate : float = 25
@export var spread : float = 2.0
@export var num_bullets : int = 1

var fire_cooldown : float = 0.0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _process(delta):
	fire_cooldown -= delta
	
	if Input.is_action_pressed("click"):
		if fire_cooldown <= 0:
			shoot(spread, num_bullets)
			fire_cooldown = 1.0 / fire_rate

func shoot(spread, num_bullets) -> void:
	
	for i in range(num_bullets):
		var bullet = bullet_scene.instantiate()
		
		bullet.position = shoot_point.global_position
		bullet.rotation = global_rotation + (rng.randf_range(-spread, spread) / 57.29578)
		bullet.direction = Vector2.RIGHT.rotated(bullet.rotation)
		
		get_tree().root.add_child(bullet)
		
		for strategy in player.upgrades:
			strategy.apply_upgrade(bullet)
		
	shoot_sound.play()
