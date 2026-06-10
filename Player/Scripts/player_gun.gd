class_name PlayerGun
extends Node2D

@onready var shoot_point : Marker2D = $ShootPoint
@onready var shoot_sound : AudioStreamPlayer = $ShootSound
@onready var pivot : Node2D = $"../../GunPivot"
@onready var player : Player = $"../../../Player"
var bullet_scene : PackedScene = preload("res://Objects/Scenes/bullet.tscn")

#gun stats
@export var base_fire_rate : float = 5.0
@export var base_spread : float = 2.0
@export var base_num_bullets : int = 1
@export var base_recoil_force : float = 20.0

var fire_rate: float
var spread: float
var num_bullets: int
var recoil_force: float

#internal stats
var fire_cooldown : float = 0.0
var rng = RandomNumberGenerator.new()
var _recoil_tween: Tween
const RECOIL_DISTANCE = 50.0
const RECOIL_RETURN_TIME = 0.2

func _ready():
	fire_rate = base_fire_rate
	spread = base_spread
	num_bullets = base_num_bullets
	recoil_force = base_recoil_force
	rng.randomize()

func _process(delta):
	fire_cooldown -= delta
	
	if Input.is_action_pressed("click"):
		if fire_cooldown <= 0:
			shoot(spread, num_bullets)
			fire_cooldown = 1.0 / fire_rate

func shoot(spread, num_bullets) -> void:
	
	for i in range(num_bullets):
		#Bullet Setup
		var bullet = bullet_scene.instantiate()
		
		bullet.position = shoot_point.global_position
		bullet.rotation = global_rotation + (rng.randf_range(-spread, spread) / 57.29578)
		bullet.direction = Vector2.RIGHT.rotated(bullet.rotation)
		
		#Applying Item Effects
		#Apply multiplicative stat upgrades
		for item in player.bullet_stat_items:
			item.apply_effects(bullet)
		
		#Apply additive stat upgrades (unused currently)
		
		#Apply on-hit debuff upgrades
		for item in player.bullet_debuff_items:
			var debuff = item.debuff.duplicate()
			debuff.source_item = item
			debuff.source = item.debuff
			bullet.on_hit_debuffs.append(debuff)
		
		#Spawn Bullet
		get_tree().root.add_child(bullet)
	
	do_recoil()
	shoot_sound.play()

func do_recoil() -> void:
	
	var recoil_direction: Vector2 = -pivot.global_transform.x.normalized()
	player.velocity += recoil_direction * recoil_force
	
	if _recoil_tween:
		_recoil_tween.kill()
	
	position.x -= RECOIL_DISTANCE
	
	_recoil_tween = create_tween()
	_recoil_tween.tween_property(self, "position:x", 115, RECOIL_RETURN_TIME).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
