extends Node3D

@export var ball_prefab: PackedScene
@export var ball_spawn_point: Node3D

@export var plunger: Node3D

func _ready() -> void:
	plunger.allow_plunge = true

#func _input(event: InputEvent):
	#if event.is_action_pressed("DEBUG_spawn_ball"):
		#
		#spawn_ball()
#
#func spawn_ball():
	##print("three_dimensions.gd: spawning ball")
	#var ball = ball_prefab.instantiate()
	#ball.position = ball_spawn_point.position
	#add_child(ball)
