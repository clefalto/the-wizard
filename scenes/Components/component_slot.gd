extends Node3D

#@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var camera = $Camera3D


func _on_button_pressed() -> void:
	print("component_slot.gd: button pressed")
