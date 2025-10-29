extends Node3D

#@onready var camera = get_tree().get_first_node_in_group("Camera")
var current_component = null
@onready var drop_area = $SlotDrop
@onready var inventory = get_tree().get_first_node_in_group("Inventory")

var component_paths = {
	TestComponent:"res://scenes/Components/Test Component/test_component.tscn",
}

func _ready() -> void:
	#print("checkign component: ", current_component)
	drop_area.dropped_component.connect(_on_assign_component)

func _on_assign_component(incoming_item: Item):
	# if we are dropping a component item
	if incoming_item is ItemComponent:
		# check if we're dropping a component onto a slot already filled!
		if current_component != null and incoming_item is ItemComponent:
			print("component_slot.gd: attempting to drop component into a slot already filled!")
			return
		
		current_component = incoming_item.component_scene.instantiate()
		current_component.item_backup = incoming_item
		current_component.free_slot.connect(_on_slot_freed)
		drop_area.visible = false
		
		self.add_child(current_component)
		inventory._on_successful_item_drop()
	
	else:
		print("component_slot.gd: dropping a non-item onto a slot!")

#func _process(delta: float) -> void:
	#print("checkign component: ", current_component)

func _on_slot_freed() -> void:
	#print("checkign component: ", current_component)
	current_component.queue_free()
	current_component = null
	drop_area.visible = true
