extends Node3D

@onready var ball_chute_wall: StaticBody3D = $BallChuteWall

func _on_ball_chute_one_way_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("ball"):
		ball_chute_wall.add_collision_exception_with(body)


func _on_ball_chute_one_way_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("ball"):
		ball_chute_wall.remove_collision_exception_with(body)
