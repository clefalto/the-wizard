extends Node3D

#@onready var camera = get_tree().get_first_node_in_group("Camera")
var current_component = null

var types = {
	TestComponent:"res://scenes/Components/Test Component/test_component.tscn",
}

func _on_button_pressed() -> void:
	print("component_slot.gd: assigning test component to: " + str(self))
	
	# we are testing wow!
	var test_component_type = TestComponent
	
	# get the path for the component we are spawning and check that it is valid
	var path = types[test_component_type]
	if not FileAccess.file_exists(path):
		print("ERROR component_slot.gd: COMPONENT PATH IS NOT LISTED CORRECTLY IN DICTIONARY")
	
	# create component and set its parent to me!
	var component = load(types[TestComponent]).instantiate()
	self.add_child(component)
