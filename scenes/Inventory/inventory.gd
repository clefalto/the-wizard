extends Control

var inventory = []

@onready var shop = get_tree().get_first_node_in_group("Shop")
@onready var ui_inventory_container = $InventorySlots


func _ready() -> void:
	# set inventory slot labels
	var slot = 1
	for i in ui_inventory_container.get_children():
		i.construct(slot)
		slot += 1
	
	# connections
	shop.buy_item.connect(_on_bought_item)


func _on_bought_item(item: Node):
	print("bought item")
