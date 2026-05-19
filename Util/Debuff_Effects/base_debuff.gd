class_name BaseDebuff
extends Resource

func on_applied(enemy: BaseEnemy) -> void:
	pass

func on_remove(enemy: BaseEnemy) -> void:
	pass

func tick(delta: float) -> bool:
	return false
