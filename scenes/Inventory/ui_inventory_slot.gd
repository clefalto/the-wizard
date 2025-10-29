extends Control

@onready var drag_button: Button = $VBoxContainer/Item/DragButton
@onready var control_item_default: Control = $VBoxContainer/Item/Default
@onready var control_item_container: Control = $VBoxContainer/Item
@onready var inventory = get_tree().get_first_node_in_group("Inventory")

var current_item: Item = null
var slot_number = 0

func construct(slot: int):
	slot_number = slot
	drag_button.slot_number = slot
	set_item(null)

func set_item(item: Item):
	print("ui_inventory_slot.gd: setting item: ", item)
	# item is removed
	if item == null:
		# delete the current item copy
		if current_item:
			current_item.queue_free()
		current_item = null
		control_item_default.visible = true
		drag_button.visible = false
		return
	
	# set item
	current_item = item
	control_item_container.add_child(current_item)
	control_item_default.visible = false
	drag_button.visible = true
	control_item_container.move_child(drag_button, current_item.get_index() +1)
	
	# change icon UI
	current_item.visible = true
	current_item.pivot_offset = current_item.size / 2.0
	var scaling: float = control_item_default.size.x / current_item.size.x 
	current_item.scale = Vector2(scaling, scaling)
	print("scaling: ", scaling)
	
	# set drag UI (TODO: MAKE A COPY OF THE ICON ITSELF SOMEHOW, PROBABLY VIEWPORTS???)
	# get color
	var color = "#ffffff"
	for i in current_item.get_children():
		if i is ColorRect:
			color = i.color
	drag_button.set_preview_color(color)
	
	

# kill button
func _on_button_pressed() -> void:
	inventory._on_remove_item_from_inventory(slot_number) # tell inventory to kill item
