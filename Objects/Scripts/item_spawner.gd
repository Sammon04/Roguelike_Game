class_name ItemSpawner
extends Node

@export var item_pool : Array[BaseItem]
@export var item_scene : PackedScene

func get_random_item() -> BaseItem:
	if item_pool.is_empty():
		return null
	return item_pool.pick_random()

func spawn_at(pos: Vector2) -> void:
	var item_pickup = item_scene.instantiate()
	var chosen_item = get_random_item()
	if chosen_item:
		item_pickup.item = chosen_item
		
		item_pickup.position = pos
		get_tree().current_scene.add_child.call_deferred(item_pickup)
