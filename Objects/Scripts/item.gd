extends Area2D

@onready var item_label : Label = $ItemLabel
@onready var sprite : Sprite2D = $ItemSprite
var item : BaseItem


func _ready() -> void:
	body_entered.connect(on_body_entered)
	sprite.texture = item.texture
	item_label.text = item.item_name

			
func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		body.collect_item(item)
		queue_free()
