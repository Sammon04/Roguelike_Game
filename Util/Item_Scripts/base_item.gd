class_name BaseItem
extends Resource

@export var item_name: String
@export var description: String
@export var texture: Texture2D

var num_held: int = 0

func on_pickup(player: Player) -> void:
	pass

func on_removed(player: Player) -> void:
	pass
