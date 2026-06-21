class_name Hurtbox
extends Area2D

signal hit(hitbox: Hitbox)

func _ready() -> void:
	area_entered.connect(emit_hit)

func emit_hit(area: Area2D) -> void:
	if area is Hitbox:
		hit.emit(area)
