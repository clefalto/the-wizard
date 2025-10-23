extends Control

@onready var inventory = get_tree().get_first_node_in_group("Inventory")

var is_active:bool = false

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	# open / close shop
	if Input.is_action_just_pressed("DEBUG_open_shop"):
		is_active = !is_active
		visible = !visible


func _on_one_pressed() -> void:
	inventory._on_bought_item("A")

func _on_two_pressed() -> void:
	inventory._on_bought_item("B")
