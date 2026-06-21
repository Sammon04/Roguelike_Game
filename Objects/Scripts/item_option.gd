extends PanelContainer

@onready var item_button : TextureButton = $VBoxContainer/ItemButton
@onready var item_label : Label = $VBoxContainer/ItemLabel

@export var item : BaseItem

func _ready() -> void:
	item_button.texture_normal = item.texture
	item_label.text = item.item_name

			
#func on_body_entered(body: PhysicsBody2D):
	#if body is Player:
		#body.collect_item(item)
		#queue_free()


func _on_button_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.collect_item(item)
	queue_free()
