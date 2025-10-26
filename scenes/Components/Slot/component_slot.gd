extends Node3D

#@onready var camera = get_tree().get_first_node_in_group("Camera")
var current_component = null
@onready var drop_area = $DropArea
@onready var inventory = get_tree().get_first_node_in_group("Inventory")

var component_paths = {
	TestComponent:"res://scenes/Components/Test Component/test_component.tscn",
}

func _ready() -> void:
	drop_area.dropped_component.connect(_on_assign_component)

func _on_assign_component(component_scene: PackedScene):
	# create component and set its parent to me!
	current_component = component_scene.instantiate()
	drop_area.visible = false
	self.add_child(current_component)
	inventory._on_successful_item_drop()
