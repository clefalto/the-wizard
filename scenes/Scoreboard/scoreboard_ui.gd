extends Control

@onready var label_container = $VBoxContainer
@export var CONTAINER_SEP = 10

@onready var chips_score_label: Label = $VBoxContainer/Chips/Score
@onready var mult_score_label: Label = $VBoxContainer/Mult/Score
@onready var balls_score_label: Label = $VBoxContainer/Balls/Score

func _ready() -> void:
	#region set UI elements
	for i in label_container.get_children():
		if i is HBoxContainer:
			i.add_theme_constant_override("separation", 20)
	
	_on_add_chips(0)
	_on_add_mult(0)
	_on_add_balls(0)
	#endregion


func _on_add_chips(score) -> void:
	chips_score_label.text = str(score)

func _on_add_mult(score) -> void:
	mult_score_label.text = str(score)

func _on_add_balls(score) -> void:
	balls_score_label.text = str(score)
