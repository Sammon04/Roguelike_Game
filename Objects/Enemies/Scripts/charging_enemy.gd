extends BaseEnemy

@onready var charge_cooldown_timer : Timer = $ChargeDelay
@onready var charge_duration_timer : Timer = $ChargeTime
@onready var melee_hitbox: Hitbox = $MeleeHitbox

@export var charge_cooldown: float
@export var charge_duration: float

var charging : bool
var ready_to_chaag : bool
var charge_direction : Vector2

func _ready():
	super()
	charging = false
	ready_to_chaag = true

func _physics_process(_delta: float) -> void:
	super(_delta)
	
	if not is_active:
		return
	
	chase_player()

func chase_player():
	if not player:
		return
	
	if charging:
		velocity = charge_direction * move_speed * (charge_duration_timer.time_left / charge_duration)
		move_and_slide()
	
	if ready_to_chaag:
		charge()
		
	if not charge_cooldown_timer.is_stopped() && not charging:
		look_at(player.global_position)
		
	

func charge():
	charging = true
	ready_to_chaag = false
	
	melee_hitbox.get_node("CollisionShape2D").disabled = false
	melee_hitbox.get_node("Sprite2D").visible = true
	
	charge_direction = (player.global_position - position).normalized()
	
	charge_duration_timer.start(charge_duration)
	charge_cooldown_timer.start(charge_cooldown + charge_duration)


func _on_charge_time_timeout() -> void:
	charging = false
	melee_hitbox.get_node("CollisionShape2D").disabled = true
	melee_hitbox.get_node("Sprite2D").visible = false


func _on_charge_delay_timeout() -> void:
	ready_to_chaag = true
