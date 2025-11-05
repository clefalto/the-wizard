class_name Component extends Node

@onready var score_manager: ScoreManager = get_tree().get_first_node_in_group("ScoreManager")
@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var destroy_buttons = $DestroyButtons
@onready var item_backup: Item

# used to calculate where to put buttons
@onready var menu_area_3d := $Area3D
@export var menu_scale := 1.0
var is_mouse_inside: bool = false

# current consumable item effects
@onready var effect_item: ItemConsumable = null
@export var main_color_mesh: MeshInstance3D = null
@onready var main_mesh_deafult_color: Color = Color.WHITE

# signal
signal free_slot()

## does nothing, but lets you polymorphically (idk if that's a word) call trigger on any component. will be useful
## when force-triggering components with other components and effects and things
## should be overridden by inheritors with the actual behavior!!!!!!!!!
func trigger():
	# call consumable effect item trigger
	if effect_item:
		print("triggered %s" % self, "\twith consumable: ", effect_item)
		effect_item.trigger()
	else:
		print("triggered %s" % self)
	
	pass

func _ready() -> void:
	# when you drop the component to the board, the mouse is going to be on the component
	_on_area_3d_mouse_entered()
	
	# get bounds of the component and use it to move menu
	var bound = GlobalFunctions.get_node_aabb(self, [destroy_buttons])
	#print("component.gd: check bounds: ", bound)
	var new_x = bound.position.x
	var new_y = bound.position.y + bound.size.y
	var new_z = bound.position.z + (bound.size.z / 2)
	var new_pos = Vector3(new_x, new_y, new_z)
	#print("component.gd: new pos: ", new_pos)
	
	destroy_buttons.position = new_pos
	destroy_buttons.look_at(camera.position)
	destroy_buttons.rotation += Vector3(deg_to_rad(0), deg_to_rad(180), deg_to_rad(0))
	destroy_buttons.scale = Vector3(menu_scale, menu_scale, menu_scale)
	
	# set destroy_buttons invisible
	destroy_buttons.visible = false
	
	# get mesh color for effects
	if main_color_mesh:
		main_mesh_deafult_color = main_color_mesh.get_surface_override_material(0).albedo_color
	
	#region set signals between components
	# destroy buttons
	var destroy_button: Button = destroy_buttons.get_interactables()["destroy_button"]
	var send_button: Button = destroy_buttons.get_interactables()["send_button"]
	var remove_effect_button: Button = destroy_buttons.get_interactables()["remove_effect_button"]
	destroy_button.pressed.connect(_on_destroy_button_pressed)
	send_button.pressed.connect(_on_send_button_pressed)
	remove_effect_button.pressed.connect(_on_remove_effect)
	#endregion

func _process(delta: float) -> void:
	# check if the mouse is inside the area3D and left click
	if is_mouse_inside and Input.is_action_just_pressed("MB_LEFT"):
		#print("component.gd: opening menu!")
		_on_open_menu()
	
	# check if the mouse is outside of destroy buttons, and left click
	if !destroy_buttons.is_mouse_inside and !is_mouse_inside and Input.is_action_just_pressed("MB_LEFT"):
		_on_close_menu()
	
	# check if we're dragging something
	if is_mouse_inside and GlobalComponent.dragged_component_scene != null and Input.is_action_just_released("MB_LEFT"):
		_on_dropped_item(GlobalComponent.dragged_component_scene.duplicate())

func _on_destroy_button_pressed() -> void:
	#print("component.gd: destroyed")
	free_slot.emit()

func _on_send_button_pressed() -> void:
	#print("component.gd: sending back to inventory", "; check item: ", item_backup)
	if !item_backup:
		return
	
	# see if inventory slot available
	# NEEDS TO BE A DUPLICATE!!! the inventory bought function queue frees the item since it
	# assumes that the item passed in is a dupe
	if inventory._on_bought_item(item_backup.duplicate()):
		free_slot.emit()

# remove effect (From button)
func _on_remove_effect():
	if !item_backup:
		return
	
	if effect_item == null:
		return
	
	# remove the item backup var and reset colors
	effect_item.queue_free()
	effect_item = null
	change_appearance_from_effect()

# dropped item on top of the menu button
func _on_dropped_item(item: Item):
	if item is ItemConsumable:
		print("component.gd: dropped consumable item: ", item)
		
		# delete previous consumable and set the new one
		if effect_item:
			effect_item.queue_free()
		effect_item = item
		add_child(effect_item)
		change_appearance_from_effect()
		
		# delete item from inventory
		inventory._on_successful_item_drop()
	
	else:
		print("component.gd: item dropped is a component! Can't drop component on component!")

# change appearance from consumable effect
func change_appearance_from_effect() -> void:
	# make sure we have a mesh to change the color / texture of
	if !main_color_mesh:
		return
	
	# if we have an active effect, else if we dont!
	var new_material = StandardMaterial3D.new()
	if effect_item:
		var color = effect_item.get_effect_color()
		new_material.albedo_color = color
		main_color_mesh.set_surface_override_material(0, new_material)
		#print("component.gd: new effect color is: ", color)
	else:
		new_material.albedo_color = main_mesh_deafult_color
		main_color_mesh.set_surface_override_material(0, new_material)

# when the slot creates me 
func set_item_backup(incoming_item: Item):
	item_backup = incoming_item
	#print("component.gd: set backup item: ", item_backup)

# opening the mini menu
func _on_open_menu() -> void:
	#print("PRESSED MENU BUTTON!")
	# need to unclick so you dont accidentyl click destroy buttons
	Input.action_release("MB_LEFT")
	menu_area_3d.input_ray_pickable = false
	destroy_buttons.set_visible(true)

# close the mini menu
func _on_close_menu() -> void:
	#print("CLOSING MENU!")
	destroy_buttons.set_visible(false)
	menu_area_3d.input_ray_pickable = true

# for opening the menu
func _on_area_3d_mouse_entered() -> void:
	is_mouse_inside = true
	#print("component.gd: is_mouse_inside: ", is_mouse_inside)

func _on_area_3d_mouse_exited() -> void:
	is_mouse_inside = false
	#print("component.gd: is_mouse_inside: ", is_mouse_inside)
