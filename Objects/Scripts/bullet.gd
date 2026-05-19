class_name Bullet
extends Area2D

@onready var anim: AnimationPlayer = $Visuals/Death
@onready var collision: CollisionShape2D = $CollisionShape2D

var on_hit_debuffs: Array[BaseDebuff] = []
var is_active : bool
var direction : Vector2 = Vector2.ZERO

#UPGRADEABLE STATS
@export var life_time : int = 1
@export var speed : int = 500
@export var damage : float = 10.0

func _ready() -> void:
	is_active = true
	despawn_on_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_active:
		return
	position += direction * speed * delta

func despawn_on_timer() -> void:
	await get_tree().create_timer(life_time).timeout
	die()

func die():
	is_active = false
	collision.disabled = true
	anim.play("death")

func _on_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			call_deferred("die")
		if body.has_method("apply_debuff"):
			for debuff in on_hit_debuffs:
				body.apply_debuff(debuff)

func _on_death_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
