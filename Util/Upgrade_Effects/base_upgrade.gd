class_name BaseUpgrade
extends Resource

@export var upgrade_name: String
@export var description: String
@export var texture: Texture2D

func on_pickup(player: Player) -> void:
	pass

func on_removed(player: Player) -> void:
	pass
