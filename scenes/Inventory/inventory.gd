extends Node

@onready var inventory_ui = $"../Control/InventoryUI"

var inventory: Array[Item] = [null, null, null, null, null]
var item_dictionary = {
	"TestComponent":ItemTestComponent
}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# test component drag stuff
	#print("inventory_ui.gd: TESTING DRAGGED ITEM: " + GlobalComponent.component_drag + "\t\t" + str(GlobalComponent.component_preview))
	
	# reset dragged item global stuff
	if GlobalComponent.component_drag != "" and Input.is_action_just_released("MB_LEFT"):
		GlobalComponent.component_drag = ""
		GlobalComponent.component_preview = null

func _on_dragging_item(slot: int, preview: Control):
	if inventory[slot] == null:
		return
	
	if inventory[slot] is not ItemComponent:
		return
	
	print("inventory.gd: dragging this item: " + str(inventory[slot].item_component_type))
	GlobalComponent.component_drag = inventory[slot].item_component_type
	GlobalComponent.component_preview = preview

func _on_bought_item(item: String):
	#check inventory for open slots
	for i in range(inventory.size()):
		if inventory[i] == null:
			# create a new node
			inventory[i] = item_dictionary[item].new()
			self.add_child(inventory[i])
			
			# update UI
			inventory_ui._on_set_item(i, item)
			return
	
	print("inventory.gd: inventory full!")

func _on_destroy_item(slot: int):
	if inventory[slot]:
		inventory[slot].queue_free()
		inventory[slot] = null
