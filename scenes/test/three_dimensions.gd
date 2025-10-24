extends Node3D

@export var ball_prefab: PackedScene
@export var ball_spawn_point: Node3D

func _input(event: InputEvent):
	if event.is_action_pressed("DEBUG_spawn_ball"):
		
		spawn_ball()

func spawn_ball():
	print("hello")
	var ball = ball_prefab.instantiate()
	ball.position = ball_spawn_point.position
	add_child(ball)
