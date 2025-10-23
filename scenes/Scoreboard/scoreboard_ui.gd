extends Control

@onready var board =  get_tree().get_first_node_in_group("Board")

@onready var label_container = $VBoxContainer
@export var CONTAINER_SEP = 10

@onready var chips_score_label: Label = $VBoxContainer/Chips/Score
@onready var mult_score_label: Label = $VBoxContainer/Mult/Score
@onready var balls_score_label: Label = $VBoxContainer/Balls/Score
var chips: float = 0
var mult: float = 0
var balls: float = 0


func _ready() -> void:
	#region set container sizes
	for i in label_container.get_children():
		if i is HBoxContainer:
			i.add_theme_constant_override("separation", 20)
	#endregion
	
	#region set signal connections
	board.scoreboard_add_chips.connect(_on_add_chips)
	board.scoreboard_add_mult.connect(_on_add_mult)
	board.scoreboard_add_balls.connect(_on_add_balls)
	#endregion


func _on_add_chips(score) -> void:
	chips += score
	chips_score_label.text = str(chips)

func _on_add_mult(score) -> void:
	mult += score
	mult_score_label.text = str(mult)

func _on_add_balls(score) -> void:
	balls += score
	balls_score_label.text = str(balls)
