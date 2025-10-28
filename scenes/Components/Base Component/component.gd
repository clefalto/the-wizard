class_name Component extends Node

@onready var score_manager = get_tree().get_first_node_in_group("ScoreManager")
@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var destroy_buttons = $DestroyButtons
@onready var menu_button = $MenuButton
@export var item_backup: Item = null

# used to calculate where to put buttons
@export var component_object: Node = null
@export var destroy_button_offset: float = 1

# signal
signal free_slot()

## does nothing, but lets you polymorphically (idk if that's a word) call trigger on any component. will be useful
## when force-triggering components with other components and effects and things
## should be overridden by inheritors with the actual behavior!!!!!!!!!
func trigger():
	print("triggered %s" % self)
	pass

func _ready() -> void:
	# get main component mesh height
	# will likely need to be changed later with more complicated stuff
	var total_height = 0
	if component_object != null:
		for i in component_object.get_children():
			if i is MeshInstance3D:
				var mesh_aabb = i.get_aabb()
				total_height += mesh_aabb.size.y
				#print("component.gd: mesh height: ", total_height)
	
	# move menu button and set signals
	menu_button.position += Vector3(0, total_height, 0)
	
	# move buttons and face camera
	destroy_buttons.position += Vector3(0, total_height + destroy_button_offset, 0)
	#destroy_buttons.look_at(camera.position)
	destroy_buttons.rotation += Vector3(deg_to_rad(90), deg_to_rad(90), deg_to_rad(0))
	
	# set destroy_buttons invisible
	destroy_buttons.visible = false
	
	#region set signals between components
	# get menu button
	var menu_button_button: Button = menu_button.node_viewport_control_instance.interactables["menu_button"]
	menu_button_button.pressed.connect(_on_menu_button_pressed)
	#print("check: ", menu_button_button)
	
	var destroy_button: Button = destroy_buttons.node_viewport_control_instance.interactables["destroy_button"]
	var send_button: Button = destroy_buttons.node_viewport_control_instance.interactables["send_button"]
	destroy_button.pressed.connect(_on_destroy_button_pressed)
	destroy_button.pressed.connect(_on_send_button_pressed)
	
	#endregion
	

func _process(delta: float) -> void:
	# check if the mouse is outside of the menu button, destroy buttons, and left click
	if !destroy_buttons.is_mouse_inside and !menu_button.is_mouse_inside and Input.is_action_just_pressed("MB_LEFT"):
		_on_close_menu()

func _on_destroy_button_pressed() -> void:
	#print("component.gd: destroyed")
	free_slot.emit()

func _on_send_button_pressed() -> void:
	#print("component.gd: sending back to inventory", "check item: ", item_backup)
	
	if item_backup == null:
		return
	
	# see if inventory slot available
	# NEEDS TO BE A DUPLICATE!!! the inventory bought function queue frees the item since it
	# assumes that the item passed in is a dupe
	if inventory._on_bought_item(item_backup.duplicate()):
		#print("bought!")
		free_slot.emit()

# opening the mini menu
func _on_menu_button_pressed() -> void:
	print("PRESSED MENU BUTTON!")
	destroy_buttons.set_visible(true)

# close the mini menu
func _on_close_menu() -> void:
	destroy_buttons.set_visible(false)
