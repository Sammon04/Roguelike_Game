@tool
extends Area2D

@export var upgrade_label : Label
@export var sprite : Sprite2D
@export var bullet_strategy : BaseBulletStrategy:
	set(val):
		bullet_strategy = val
		needs_update = true

@export var needs_update : bool = false

func _ready() -> void:
	body_entered.connect(on_body_entered)
	sprite.texture = bullet_strategy.texture
	upgrade_label.text = bullet_strategy.upgrade_text

func _process(delta: float) -> void:
	
	if Engine.is_editor_hint():
		if needs_update:
			sprite.texture = bullet_strategy.texture
			upgrade_label.text = bullet_strategy.upgrade_text
			needs_update = false
			
func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		body.upgrades.append(bullet_strategy)
		queue_free()
