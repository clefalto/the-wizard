extends Node3D

signal scoreboard_add_chips(amount: float)
signal scoreboard_add_mult(amount: float)
signal scoreboard_add_balls(amount: float)

#region debug
func _process(delta: float) -> void:
	if Input.is_action_pressed("DEBUG_add_chips"):
		print("adding chips")
		scoreboard_add_chips.emit(1)
	if Input.is_action_pressed("DEBUG_add_mult"):
		print("adding mult")
		scoreboard_add_mult.emit(1)
	if Input.is_action_pressed("DEBUG_add_balls"):
		print("adding balls")
		scoreboard_add_balls.emit(1)

#endregion
