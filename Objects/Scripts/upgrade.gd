extends Area2D

@export var upgrade_label : Label
@export var sprite : Sprite2D
@export var bullet_strategy : BaseBulletStrategy


func _ready() -> void:
	body_entered.connect(on_body_entered)
	sprite.texture = bullet_strategy.texture
	upgrade_label.text = bullet_strategy.upgrade_text

			
func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		body.upgrades.append(bullet_strategy)
		queue_free()
