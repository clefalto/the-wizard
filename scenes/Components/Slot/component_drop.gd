extends Node3D

# taken from godot examples
var is_mouse_inside: bool = false # check if mouse is in area3d
var last_event_pos2D := Vector2() # the last processed input event, used to calculate relative movement
var last_event_time := -1.0 # time of the last event in seconds

@onready var node_viewport: SubViewport = $SubViewport
@onready var node_quad: MeshInstance3D = $Quad
@onready var node_area: Area3D = $Quad/Area3D

signal dropped_component(component: String)

var held_component = null

func _ready() -> void:
	node_area.mouse_entered.connect(_mouse_entered_area)
	node_area.mouse_exited.connect(_mouse_exited_area)
	node_area.input_event.connect(_mouse_input_event)


func _process(delta: float) -> void:
	if is_mouse_inside and GlobalComponent.component_drag != "" and Input.is_action_just_released("MB_LEFT"):
		print("dropped: " + GlobalComponent.component_drag)
		
		dropped_component.emit(GlobalComponent.component_drag)

#region mouse inputs

# mouse entered and exited
func _mouse_entered_area() -> void:
	is_mouse_inside = true
	
	# Notify the viewport that the mouse is now hovering it.
	node_viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)

func _mouse_exited_area() -> void:
	# Notify the viewport that the mouse is no longer hovering it.
	node_viewport.notification(NOTIFICATION_VP_MOUSE_EXIT)
	is_mouse_inside = false

func _unhandled_input(input_event: InputEvent) -> void:
	# check if event is a non-mouse event
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion]:
		# if it is a mouse event then dw about it here, it'll be handled later
		if is_instance_of(input_event, mouse_event):
			return
	
	node_viewport.push_input(input_event)

# mouse inputs
func _mouse_input_event(_camera: Camera3D, input_event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var quad_mesh_size: Vector2 = node_quad.mesh.size # mesh size to detect edges
	var event_pos3D := event_position # event position in Area3D in world coords
	var now := Time.get_ticks_msec() / 1000.0 # current time since engine start
	
	# Convert position to a coordinate space relative to Area3D
	event_pos3D = node_quad.global_transform.affine_inverse() * event_pos3D # affine inverse accounts for Area3D node's scale, rotation, and pos
	
	var event_pos2D := Vector2()
	
	if is_mouse_inside:
		# convert relative event pos from 3d to 2d
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)
		
		# the pos range is currently (-quad_size/2, quad_size/2)
		# convert range to (-0.5, 0.5), and then to (0, 1)
		event_pos2D.x = (event_pos2D.x / quad_mesh_size.x) + 0.5
		event_pos2D.y = (event_pos2D.y / quad_mesh_size.y) + 0.5
		
		# now the event pos is in the viewport's coordinate system
	
	# fall back to last known event pos
	elif last_event_pos2D != null:
		event_pos2D = last_event_pos2D
	
	# set event's position and global position
	input_event.position = event_pos2D
	if input_event is InputEventMouse:
		input_event.global_position = event_pos2D
	
	# calculate relative event distance
	if input_event is InputEventMouseMotion or input_event is InputEventScreenDrag:
		# if there is not a stored previous position, we'll assume theres no relative motion
		if last_event_pos2D == null:
			input_event.relative = Vector2(0,0)
		
		# if there is, we calculate the relative pos by subtracting, this gives us the distance the event travelled
		else:
			input_event.relative = event_pos2D - last_event_pos2D
			input_event.velocity = input_event.relative / (now - last_event_time)
	
	
	# update last event pos with the new pos
	last_event_pos2D = event_pos2D 
	last_event_time = now
	
	# send processed input to the viewport
	node_viewport.push_input(input_event)


#endregion
