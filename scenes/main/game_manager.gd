extends Node2D

var ball: RigidBody2D
var ball_scn = preload("res://scenes/ball/rigid_balldy.tscn")
@export var drain_zone: Area2D

func _ready():
	ball = get_tree().get_first_node_in_group("ball")
	
	drain_zone.ball_drained.connect(on_ball_drained)

func reset_ball():
	ball.queue_free()
	ball = ball_scn.instantiate()
	get_tree().root.add_child(ball)

func on_ball_drained():
	reset_ball()
