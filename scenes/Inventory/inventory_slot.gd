extends Control

@onready var slot_number_label: Label = $VBoxContainer/Control/SlotNumber

var current_item = null
var slot_number = 0

func construct(slot: int):
	slot_number = slot
	slot_number_label.text = str(slot)

func set_item(item: String):
	# item is removed
	if item == "":
		slot_number_label.text = str(slot_number)
		return
	
	# set item
	slot_number_label.text = item


func _on_button_pressed() -> void:
	set_item("") # destroy item
