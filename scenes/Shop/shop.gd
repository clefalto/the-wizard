extends Control

var is_active:bool = false

signal buy_item(item: Node)

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	# open / close shop
	if Input.is_action_just_pressed("DEBUG_open_shop"):
		is_active = !is_active
		visible = !visible


func _on_button_pressed() -> void:
	buy_item.emit(null)
