extends Node3D

@onready var score_manager = get_tree().get_first_node_in_group("ScoreManager")

#region debug
func _process(delta: float) -> void:
	if Input.is_action_pressed("DEBUG_add_chips"):
		score_manager._on_add_chips(1)
	if Input.is_action_pressed("DEBUG_add_mult"):
		score_manager._on_add_mult(1)
	if Input.is_action_pressed("DEBUG_add_balls"):
		score_manager._on_add_balls(1)

#endregion
