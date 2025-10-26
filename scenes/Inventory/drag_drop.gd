extends Button

var slot_number = 0
@onready var inventory = get_tree().get_first_node_in_group("Inventory")

func _ready() -> void:
	visible = false

# returns the data to pass from an object when you click and drag away from this object
func _get_drag_data(_at_position: Vector2) -> String:
	#print("drag_drop.gd: dragging new item")
	
	var cpb := ColorPickerButton.new()
	cpb.color = Color("#00b1b1")
	cpb.size = Vector2(25.0, 25.0)

	# Allows us to center the color picker on the mouse.
	var preview := Control.new()
	preview.add_child(cpb)
	cpb.position = -0.5 * cpb.size

	# Sets what the user will see they are dragging.
	set_drag_preview(preview)
	
	print("drag_drop.gd test: " + str(slot_number))
	inventory._on_dragging_item(slot_number)
	return ""


#
## check to see if data being dragged is valid
#func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	##print("drag_drop.gd: can drop?")
	#return typeof(data) == TYPE_STRING
#
#func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#print("drag_drop.gd: dropped!")
