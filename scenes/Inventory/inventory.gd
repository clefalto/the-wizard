extends Node

@onready var inventory_ui = $"../Control/InventoryUI"

var inventory: Array[Item] = [null, null, null, null, null]
var item_dictionary = {
	"chips":ItemChips,
	"mult":ItemMult,
	"balls":ItemBalls,
}

func _ready() -> void:
	pass

func _on_bought_item(item: String):
	var temp = item_dictionary[item]
	
	#check inventory for open slots
	for i in range(inventory.size()):
		if inventory[i] == null:
			# create a new node
			inventory[i] = temp.new()
			self.add_child(inventory[i])
			
			# update UI
			inventory_ui._on_set_item(i, item)
			return
	
	print("inventory.gd: inventory full!")

func _on_destroy_item(slot: int):
	if inventory[slot]:
		inventory[slot].queue_free()
		inventory[slot] = null
