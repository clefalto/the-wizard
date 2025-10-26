extends Control

@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var item_container_parent = $VBoxContainer

var is_active:bool = false

func _ready() -> void:
	visible = false
	
	for i in item_container_parent.get_children():
		for j in i.get_children():
			var button = Button.new()
			button.size = Vector2(40, 40)
			button.set_anchors_preset(PRESET_FULL_RECT)
			button.position = j.position
			
			button.pressed.connect(_on_item_bought.bind(j))
			
			j.add_child(button)
	

func _process(delta: float) -> void:
	# open / close shop
	if Input.is_action_just_pressed("DEBUG_open_shop"):
		is_active = !is_active
		visible = !visible


func _on_item_bought(item: Item):
	#print("shop_ui.gd: buying: " + str(item))
	
	var new_item = item.duplicate()
	for i in new_item.get_children():
		i.queue_free()
	
	inventory._on_bought_item(new_item)
