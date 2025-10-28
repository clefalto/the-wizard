extends Node

@onready var balls_remaining: int = 3 # how many balls we have left for this round
@onready var ball_count_label: Label3D = $BallCount

@export var ball_drain: Area3D
@export var ball_plunger: Node3D

func _ready():
	ball_drain.ball_drained.connect(on_ball_drain)
	
	ball_plunger.allow_plunge = true
	ball_count_label.text = "balls: %s" % balls_remaining

func use_ball() -> void:
	if balls_remaining <= 0:
		print("fresh out of balls, round should end")
	else:
		balls_remaining -= 1
	ball_count_label.text = "balls: %s" % balls_remaining

func on_ball_drain():
	ball_plunger.allow_plunge = true
