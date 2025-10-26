extends Node

@onready var inventory_ui = $"../Control/InventoryUI"

var inventory: Array[Item] = [null, null, null, null, null]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# test component drag stuff
	#print("inventory_ui.gd: TESTING DRAGGED ITEM: " + str(GlobalComponent.dragged_component_scene))
	
	# reset dragged item global stuff
	if GlobalComponent.dragged_component_scene != null and Input.is_action_just_released("MB_LEFT"):
		GlobalComponent.dragged_component_scene = null

# dragging and dropping item component to board
func _on_dragging_item(slot: int):
	if inventory[slot] is ItemComponent:
		#print("inventory.gd: dragging this item: " + str(inventory[slot].component_scene))
		GlobalComponent.dragged_component_scene = inventory[slot].component_scene

func _on_bought_item(item: Item):
	#check inventory for open slots
	for i in range(inventory.size()):
		if inventory[i] == null:
			# create a new node
			inventory[i] = item
			self.add_child(inventory[i])
			
			# update UI
			inventory_ui._on_set_item(i, item.item_name)
			print(inventory)
			return
	
	print("inventory.gd: inventory full!")

func _on_destroy_item(slot: int):
	if inventory[slot]:
		inventory[slot].queue_free()
		inventory[slot] = null
