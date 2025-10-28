extends Area3D

#@onready var ball_manager: Node = get_tree().get_first_node_in_group("BallManager") # good programming practices? i hardly know uhh them

signal ball_drained

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("ball"):
		body.queue_free()
	ball_drained.emit()
