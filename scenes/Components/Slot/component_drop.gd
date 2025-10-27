extends ViewportMouseInput

signal dropped_component(component: PackedScene)

var held_component = null

func _process(delta: float) -> void:
	if is_mouse_inside and GlobalComponent.dragged_component_scene != null and Input.is_action_just_released("MB_LEFT"):
		#print("component_drop.dg: dropped: " + str(GlobalComponent.dragged_component_scene))
		
		dropped_component.emit(GlobalComponent.dragged_component_scene)
