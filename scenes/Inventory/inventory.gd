extends Node

@onready var inventory_ui = $"../Control/InventoryUI"

var inventory: Array[Item] = [null, null, null, null, null]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# test component drag stuff
	#print("inventory_ui.gd: TESTING DRAGGED ITEM: " + str(GlobalComponent.dragged_component_scene) + "\t\tSLOT: " + str(GlobalComponent.dragged_inventory_slot))
	
	# reset dragged item global stuff
	if GlobalComponent.dragged_component_scene != null and Input.is_action_just_released("MB_LEFT"):
		GlobalComponent.dragged_component_scene.queue_free()
		GlobalComponent.dragged_component_scene = null
		GlobalComponent.dragged_inventory_slot = -1

# dragging and dropping item component to board
func _on_dragging_item(slot: int):
	if inventory[slot] is Item:
		#print("inventory.gd: dragging this item: " + str(inventory[slot]))
		GlobalComponent.dragged_component_scene = inventory[slot].duplicate()
		GlobalComponent.dragged_inventory_slot = slot

# we've dropped an item wowie
func _on_successful_item_drop():
	_on_remove_item_from_inventory(GlobalComponent.dragged_inventory_slot)

# buy and kill items
func _on_bought_item(item: Item) -> bool:
	#check inventory for open slots
	for i in range(inventory.size()):
		if inventory[i] == null:
			# create a new node
			inventory[i] = item
			self.add_child(inventory[i])
			
			# update UI
			inventory_ui._on_set_item(i, item.duplicate())
			#print("inventory.gd: Inventroy: ", inventory)
			return true
	
	print("inventory.gd: inventory full!")
	item.queue_free()
	return false

func _on_remove_item_from_inventory(slot: int):
	#print("destroying: " + str(slot))
	if inventory[slot]:
		# delete the item copies in basckend and UI
		inventory_ui._on_set_item(slot, null)
		inventory[slot].queue_free()
		inventory[slot] = null
