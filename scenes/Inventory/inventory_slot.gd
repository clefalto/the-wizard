extends Control

@onready var drag_button: Button = $VBoxContainer/Item/DragButton
@onready var slot_number_label: Label = $VBoxContainer/Item/SlotNumber
@onready var inventory = get_tree().get_first_node_in_group("Inventory")

var current_item: String = ""
var slot_number = 0

func construct(slot: int):
	slot_number = slot
	drag_button.slot_number = slot
	set_item("")

func set_item(item: String):
	# item is removed
	if item == "":
		slot_number_label.text = "[" + str(slot_number + 1) + "]"
		drag_button.visible = false
		return
	
	# set item
	current_item = item
	drag_button.visible = true
	slot_number_label.text = item

# kill button
func _on_button_pressed() -> void:
	set_item("") # destroy item
	inventory._on_destroy_item(slot_number - 1) # tell inventory to kill item
