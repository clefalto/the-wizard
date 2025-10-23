class_name Item extends Node

@onready var score_manager = get_tree().get_first_node_in_group("ScoreManager")

@export var item_name: String = "item"
var is_active: bool = false
