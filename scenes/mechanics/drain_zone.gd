extends Area2D

signal ball_drained

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		ball_drained.emit()
