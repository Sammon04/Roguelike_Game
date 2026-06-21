class_name Player
extends CharacterBody2D

@onready var gun: PlayerGun = $"GunPivot/Gun"
@onready var movement: PlayerMovement = $PlayerMovement
@onready var hurtbox: Hurtbox = $Hurtbox

var health: float = 100.0
var held_items : Array[BaseItem] = []
var bullet_stat_items : Array[BulletStatItem] = []
var bullet_debuff_items : Array[BulletDebuffItem] = []

func _ready() -> void:
	hurtbox.hit.connect(_on_hit)

func collect_item(item: BaseItem):
	var existing = get_if_held(item)
	if existing:
		existing.num_held += 1
		existing.on_pickup(self)
	else:
		item.num_held = 1
		held_items.append(item)
		item.on_pickup(self)
		if item is BulletStatItem:
			bullet_stat_items.append(item)
			
		if item is BulletDebuffItem:
			bullet_debuff_items.append(item)

func get_if_held(item: BaseItem) -> BaseItem:
	for held_item in held_items:
		if held_item == item:
			return held_item
	return null

func _on_hit(hitbox: Hitbox) -> void:
	take_damage(hitbox)

func take_damage(hitbox: Hitbox) -> void:
	health -= hitbox.damage
	print("player health: ", health)
