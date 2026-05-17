extends Area2D

@onready var item_label : Label = $ItemLabel
@onready var sprite : Sprite2D = $ItemSprite
var upgrade : BaseUpgrade


func _ready() -> void:
	body_entered.connect(on_body_entered)
	sprite.texture = upgrade.texture
	item_label.text = upgrade.upgrade_name

			
func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		body.held_items.append(upgrade)
		upgrade.on_pickup(body)
		body.collect_item(upgrade)
		queue_free()
