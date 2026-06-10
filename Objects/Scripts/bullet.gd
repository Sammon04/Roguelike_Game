class_name Bullet
extends Area2D

@onready var anim: AnimationPlayer = $Visuals/Death
@onready var collision: CollisionShape2D = $CollisionShape2D

var on_hit_debuffs: Array[BaseDebuff] = []
var is_active : bool
var direction : Vector2 = Vector2.ZERO

#UPGRADEABLE STATS
@export var base_life_time : float = 1.0
@export var base_speed : float = 500.0
@export var base_damage : float = 10.0
@export var base_pierce: int = 1
@export var base_explosion_radius: float = 20.0

var life_time : float = base_life_time
var speed : float = base_speed
var damage : float = base_damage
var pierce: int = base_pierce
var explosion_radius: float = base_explosion_radius

func _ready() -> void:
	is_active = true
	despawn_on_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_active:
		return
	position += direction * speed * delta

func despawn_on_timer() -> void:
	await get_tree().create_timer(life_time, false).timeout
	die()

func die():
	is_active = false
	collision.disabled = true
	anim.play("death")

func _on_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if body.has_method("apply_debuff"):
			for debuff in on_hit_debuffs:
				body.apply_debuff(debuff)
		pierce -= 1
		if pierce <= 0:
			call_deferred("die")

func _on_death_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
