class_name Enemy
extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player") as Player
@onready var anim: AnimationPlayer = $Visuals/AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health_bar: ProgressBar = $HealthBar
@export var enemy_speed = 200
@export var max_health: int = 100
var health: int
var is_active: bool
var dead : bool
signal enemy_died


func _ready() -> void:
	visible = false
	is_active = false
	dead = false
	collision.disabled = true
	anim.play("spawn")
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar.visible = false

func _process(delta: float) -> void:
	if not is_active:
		return
	follow_player()
	$HealthBar.global_position = global_position + Vector2(-20, -40)

func follow_player():
	if player:
		var direction = player.global_position - position
		direction = direction.normalized()
		velocity = direction * enemy_speed
		move_and_slide()
		look_at(player.global_position)

func take_damage(amount: int):
	health -= amount
	health_bar.value = health
	health_bar.visible = true
	
	if health <= 0:
		die()

func die():
	if dead:
		return
	
	dead = true
	enemy_died.emit()
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn":
		is_active = true
		collision.disabled = false
