extends Node

@onready var inventory_ui = $"../Control/InventoryUI"

var inventory = [null, null, null, null, null]

func _ready() -> void:
	pass

func _on_bought_item(item: String):
	# check inventory for open slots
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			inventory_ui._on_set_item(i, item)
			return
	
	print("inventory.gd: coudln't buy!")

func _on_destroy_item(slot: int):
	inventory[slot] = null
