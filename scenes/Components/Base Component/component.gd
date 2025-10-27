class_name Component extends Node

@onready var score_manager = get_tree().get_first_node_in_group("ScoreManager")
@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var destroy_buttons = $DestroyButtons

# used to calculate where to put buttons
@export var component_object: Node = null
@export var destroy_button_offset: float = 1

## does nothing, but lets you polymorphically (idk if that's a word) call trigger on any component. will be useful
## when force-triggering components with other components and effects and things
## should be overridden by inheritors with the actual behavior!!!!!!!!!
func trigger():
	print("triggered %s" % self)
	pass

func _ready() -> void:
	# get main component mesh height
	var total_height = 0
	if component_object != null:
		for i in component_object.get_children():
			if i is MeshInstance3D:
				var mesh_aabb = i.get_aabb()
				total_height += mesh_aabb.size.y
				print("component.gd: mesh height: ", total_height)
	
	# move buttons
	destroy_buttons.position += Vector3(0, total_height + destroy_button_offset, 0)
	
	print("rot: ", destroy_buttons.rotation)
	
	destroy_buttons.look_at(camera.global_position)
	
	print("rot: ", destroy_buttons.rotation)
	
	destroy_buttons.rotation += Vector3(deg_to_rad(90), deg_to_rad(0), deg_to_rad(180))
	
	print("rot: ", destroy_buttons.rotation)


func _on_destroy_button_pressed() -> void:
	print("component.gd: destroyed")

func _on_send_button_pressed() -> void:
	print("component.gd: sending back to inventory")
