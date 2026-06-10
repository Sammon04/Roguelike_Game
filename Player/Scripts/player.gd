class_name Player
extends CharacterBody2D

@onready var gun: PlayerGun = $"GunPivot/Gun"
@onready var movement: PlayerMovement = $PlayerMovement

var held_items : Array[BaseItem] = []
var bullet_stat_items : Array[BulletStatItem] = []
var bullet_debuff_items : Array[BulletDebuffItem] = []

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
