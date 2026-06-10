class_name SpawnRegion
extends Polygon2D

var _bounding_rect: Rect2

func _ready() -> void:
	_bounding_rect = _get_bounding_rect()

func get_random_point(player: Player) -> Vector2:
	var rect = _bounding_rect
	var attempts = 0
	while attempts < 50:
		var point = Vector2(
			randf_range(rect.position.x, rect.end.x),
			randf_range(rect.position.y, rect.end.y)
		)
		if Geometry2D.is_point_in_polygon(point, polygon) \
		&& point.distance_to(player.global_position) >= 200:
			return global_position + point
	return global_position

func _get_bounding_rect() -> Rect2:
	var min_pos = polygon[0]
	var max_pos = polygon[0]
	for point in polygon:
		min_pos = min_pos.min(point)
		max_pos = max_pos.max(point)
	return Rect2(min_pos, max_pos - min_pos)
