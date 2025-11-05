extends ViewportMouseInput

func _ready() -> void:
	super._ready()
	
	# shift the quad in destroy buttons to mimic an anchor
	var bounds = GlobalFunctions.get_node_aabb(node_quad, [])
	#print("menu_viewport_input.gd: bounds: ", bounds)
	node_quad.position.z -= bounds.size.z / 2
