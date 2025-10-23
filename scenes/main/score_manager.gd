extends Node

@onready var ui_scoreboard = $"../Control/ScoreboardUI"

var chips: float = 0
var mult: float = 0
var balls: float = 0


func _on_add_chips(score: float):
	chips += score
	ui_scoreboard._on_add_chips(chips)

func _on_add_mult(score: float):
	mult += score
	ui_scoreboard._on_add_mult(mult)

func _on_add_balls(score: float):
	balls += score
	ui_scoreboard._on_add_balls(balls)
