extends Control

@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var item_container_parent = $VBoxContainer

var is_active:bool = false

func _ready() -> void:
	visible = false
	
	for i in item_container_parent.get_children():
		for item in i.get_children():
			print("test item: ", item)
			var button = Button.new()
			item.add_child(button)
			button.size = item.size
			button.modulate.a = 0.3
			
			button.pressed.connect(_on_item_bought.bind(item))
			
	

func _process(delta: float) -> void:
	# open / close shop
	if Input.is_action_just_pressed("DEBUG_open_shop"):
		is_active = !is_active
		visible = !visible


func _on_item_bought(item: Item):
	print("shop_ui.gd: buying: " + str(item))
	
	var new_item = item.duplicate()
	new_item.visible = false
	for i in new_item.get_children():
		if i is Button:
			print("testing i: ", i)
			new_item.remove_child(i)
			i.queue_free()
	
	inventory._on_bought_item(new_item)
