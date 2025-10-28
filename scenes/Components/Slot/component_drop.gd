extends ViewportMouseInput

signal dropped_component(component: Item)

var held_component = null

func _ready() -> void:
	super._ready()
	set_process(true) 

func _process(delta: float) -> void:
	super._process(delta)
	
	#print("check mouse inside: ", is_mouse_inside, "check global scene: ", GlobalComponent.dragged_component_scene, "check input: ", Input.is_action_just_released("MB_LEFT"))
	if is_mouse_inside and GlobalComponent.dragged_component_scene != null and Input.is_action_just_released("MB_LEFT"):
		#print("component_drop.dg: dropped: " + str(GlobalComponent.dragged_component_scene))
		dropped_component.emit(GlobalComponent.dragged_component_scene)
