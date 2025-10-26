extends Node3D

#@onready var camera = get_tree().get_first_node_in_group("Camera")
var current_component = null
@onready var drop_area = $DropArea

var component_paths = {
	TestComponent:"res://scenes/Components/Test Component/test_component.tscn",
}

func _ready() -> void:
	drop_area.dropped_component.connect(assign_component)

func _on_button_pressed() -> void:
	print("component_slot.gd: assigning test component to: " + str(self))
	
	# we are testing wow!
	assign_component(component_paths[TestComponent])


func assign_component(component_path: String):
	if not FileAccess.file_exists(component_path):
		print("ERROR component_slot.gd: COMPONENT PATH IS NOT LISTED CORRECTLY IN DICTIONARY")
	
	# create component and set its parent to me!
	current_component = load(component_paths[TestComponent]).instantiate()
	self.add_child(current_component)
	
	
