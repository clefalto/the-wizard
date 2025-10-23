extends Control

@onready var inventory = [
	$InventorySlots/InventorySlot, 
	$InventorySlots/InventorySlot2, 
	$InventorySlots/InventorySlot3, 
	$InventorySlots/InventorySlot4, 
	$InventorySlots/InventorySlot5
]

@onready var shop = get_tree().get_first_node_in_group("Shop")
@onready var ui_inventory_container = $InventorySlots

func _ready() -> void:
	# set inventory slot labels
	var slot = 1
	for i in ui_inventory_container.get_children():
		i.construct(slot)
		slot += 1

func _on_set_item(slot: int, text: String):
	inventory[slot].set_item(text)
