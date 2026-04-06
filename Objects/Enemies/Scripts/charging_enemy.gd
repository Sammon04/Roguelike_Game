extends BaseEnemy

@onready var charge_cooldown_timer : Timer = $ChargeDelay
@onready var charge_duration_timer : Timer = $ChargeTime
@export var charge_cooldown: int
@export var charge_duration: int

var charging : bool
var ready_to_chaag : bool
var charge_direction : Vector2

func _init():
	enemy_speed = 500
	max_health = 150

func _ready():
	super()
	charge_cooldown = 1
	charge_duration = 1
	charging = false
	ready_to_chaag = true

func follow_player():
	if not player:
		return
	
	if charging:
		velocity = charge_direction * enemy_speed * (charge_duration_timer.time_left / charge_duration)
		move_and_slide()
	
	if ready_to_chaag:
		charge()
		
	if not charge_cooldown_timer.is_stopped() && not charging:
		look_at(player.global_position)
		
	

func charge():
	charging = true
	ready_to_chaag = false
	
	charge_direction = (player.global_position - position).normalized()
	
	charge_duration_timer.start(charge_duration)
	charge_cooldown_timer.start(charge_cooldown + charge_duration)


func _on_charge_time_timeout() -> void:
	charging = false


func _on_charge_delay_timeout() -> void:
	ready_to_chaag = true
