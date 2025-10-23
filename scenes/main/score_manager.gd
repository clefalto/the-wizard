extends Node

@onready var ui_scoreboard = $"../Control/ScoreboardUI"

var points: float = 0
var mult: float = 0
var balls: float = 0


func _on_add_points(score: float):
	points += score
	ui_scoreboard._on_add_points(points)

func _on_add_mult(score: float):
	mult += score
	ui_scoreboard._on_add_mult(mult)

func _on_add_balls(score: float):
	balls += score
	ui_scoreboard._on_add_balls(balls)
