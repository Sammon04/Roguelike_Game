extends Node2D
class_name DamageNumberSpawner

@export var label_settings: LabelSettings

func spawn_damage_number(number: float) -> void:
	var label: Label = Label.new()
	
	label.text = str(number if step_decimals(number) != 0 else number as int)
	label.label_settings = label_settings.duplicate()
	label.z_index = 1000
	label.pivot_offset_ratio = Vector2(0.5, 1.0)
	label.top_level = true
	
	call_deferred("add_child", label)
	await label.resized
	label.global_position = global_position
	label.position -= Vector2(label.size.x / 2.0, label.size.y)
	
	#random offset
	#label.position += Vector2(ranf_range(-5.0, 5.0), randf_range(-5.0, 5.0))
	
	#animation tweens
	#causes the label to rise
	#change this section to affect how the label moves
	var target_rise_pos: Vector2 = label.position + Vector2(randf_range(-5.0, 5.0), randf_range(-22.0, -16.0))
	var tween_length: float = 0.92
	var label_tween: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label_tween.tween_property(label, "position", target_rise_pos, tween_length)
	label_tween.parallel().tween_property(label, "scale", Vector2.ONE * 1.35, tween_length)
	label_tween.parallel().tween_property(label, "modulate:a", 0.0, tween_length).connect("finished", label.queue_free)
	
