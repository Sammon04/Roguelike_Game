extends BaseEnemy

@onready var attack_range: Area2D = $AttackRange
@onready var melee_hitbox: Hitbox = $MeleeHitbox

@export var attack_windup: float = 0.15
@export var attack_duration: float = 0.1
@export var attack_cooldown: float = 0.5

enum State { CHASING, WINDUP, COOLDOWN }
var state: State = State.CHASING

func _ready() -> void:
	super()
	
	attack_range.body_entered.connect(_body_entered_attack_range)
	melee_hitbox.damage = base_damage

func _physics_process(_delta: float) -> void:
	super(_delta)
	
	if not is_active:
		return
	
	match state:
		State.CHASING:
			chase_player()
		State.WINDUP, State.COOLDOWN:
			velocity = Vector2.ZERO
			move_and_slide()

func chase_player() -> void:
	if not player:
		return
		
	var direction = (player.global_position - position).normalized()
	velocity = direction * move_speed
	
	move_and_slide()
	look_at(player.global_position)

func _body_entered_attack_range(body: Node2D) -> void:
	if body is Player and state == State.CHASING:
		attack()

func attack() -> void:
	while not dead:
		state = State.WINDUP
		await get_tree().create_timer(attack_windup, false).timeout
		if dead:
			return
		
		melee_hitbox.get_node("CollisionShape2D").disabled = false
		melee_hitbox.get_node("Sprite2D").visible = true
		
		await get_tree().create_timer(attack_duration, false).timeout
		melee_hitbox.get_node("CollisionShape2D").disabled = true
		melee_hitbox.get_node("Sprite2D").visible = false
		
		state = State.COOLDOWN
		await get_tree().create_timer(attack_cooldown, false).timeout
		state = State.CHASING
		
		var player_in_range: bool = attack_range.get_overlapping_bodies().any(
			func(b): return b is Player
		)
		if not player_in_range:
			break
