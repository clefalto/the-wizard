class_name Component extends Node

@onready var score_manager = get_tree().get_first_node_in_group("ScoreManager")
@onready var inventory = get_tree().get_first_node_in_group("Inventory")

## does nothing, but lets you polymorphically (idk if that's a word) call trigger on any component. will be useful
## when force-triggering components with other components and effects and things
## should be overridden by inheritors with the actual behavior!!!!!!!!!
func trigger():
	print("triggered %s" % self)
	pass


func _on_destroy_button_pressed() -> void:
	print("component.gd: destroyed")
