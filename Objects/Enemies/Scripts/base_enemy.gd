class_name BaseEnemy
extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player") as Player
@onready var anim: AnimationPlayer = $Visuals/AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health_bar: ProgressBar = $HealthBar

@export var credits = 0
@export var enemy_speed = 0
@export var max_health: int = 0

var health: int
var active_debuffs: Array[BaseDebuff] = []
var is_active: bool = false
var dead : bool = false
signal enemy_died


func _ready() -> void:
	visible = false
	collision.disabled = true
	anim.play("spawn")
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar.visible = false

func _process(delta: float) -> void:
	for debuff in active_debuffs.duplicate():
		if debuff.tick(delta):
			debuff.on_remove(self)
			active_debuffs.erase(debuff)

func _physics_process(_delta: float) -> void:
	if not is_active:
		return
	follow_player()
	$HealthBar.global_position = global_position + Vector2(-20, -40)

func follow_player():
	if not player:
		return
		
	var direction = (player.global_position - position).normalized()
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
	
	for debuff in active_debuffs:
		debuff.on_remove(self)
	active_debuffs.clear()
	
	dead = true
	enemy_died.emit()
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn":
		is_active = true
		collision.disabled = false

func apply_debuff(debuff: BaseDebuff) -> void:
	if debuff is ActiveDebuff:
		for active in active_debuffs:
			if active is ActiveDebuff and active.source == debuff:
				active.add_stack()
				return
	
	var instance = debuff.duplicate()
	
	if instance is ActiveDebuff:
		instance.source = debuff
		
	active_debuffs.append(instance)
	instance.on_applied(self)
