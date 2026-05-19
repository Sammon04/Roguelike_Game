class_name Player
extends CharacterBody2D

@onready var gun: PlayerGun = $"GunPivot/Gun"
@onready var movement: PlayerMovement = $PlayerMovement

var held_items : Array[BaseUpgrade] = []
var bullet_stat_upgrades : Array[BulletStatUpgrade] = []
var bullet_debuff_upgrades : Array[BulletDebuffUpgrade] = []

func collect_item(upgrade: BaseUpgrade):
	if upgrade is BulletStatUpgrade:
		bullet_stat_upgrades.append(upgrade)
	if upgrade is BulletDebuffUpgrade:
		print("Debuff Upgrade Added")
		bullet_debuff_upgrades.append(upgrade)
		
	
