class_name ViewportMouseInput extends Node

# taken from godot examples
var is_mouse_inside: bool = false # check if mouse is in area3d
var last_event_pos2D := Vector2() # the last processed input event, used to calculate relative movement
var last_event_time := -1.0 # time of the last event in seconds

@export var node_viewport: SubViewport = null
@export var node_quad: MeshInstance3D = null
@export var node_area: Area3D = null

func _ready() -> void:
	var is_safe: bool = true
	
	# node var checks
	if node_viewport == null:
		print(str(self) + ": ERROR: node_viewport UNSET")
		is_safe = false
	if node_quad == null:
		print(str(self) + ": ERROR: node_quad UNSET")
		is_safe = false
	if node_area == null:
		print(str(self) + ": ERROR: node_area UNSET")
		is_safe = false
	
	if !is_safe:
		print(str(self) + ": ERROR: node var unset. freeing self.")
		self.queue_free()
		return
	
	node_area.mouse_entered.connect(_mouse_entered_area)
	node_area.mouse_exited.connect(_mouse_exited_area)
	node_area.input_event.connect(_mouse_input_event)
	
	# If the material is NOT set to use billboard settings, then avoid running billboard specific code
	if node_quad.get_surface_override_material(0).billboard_mode == BaseMaterial3D.BillboardMode.BILLBOARD_DISABLED:
		set_process(false)

func _process(_delta: float) -> void:
	# NOTE: Remove this function if you don't plan on using billboard settings.
	rotate_area_to_billboard()
	pass

func rotate_area_to_billboard() -> void:
	var billboard_mode: BaseMaterial3D.BillboardMode = node_quad.get_surface_override_material(0).billboard_mode

	# Try to match the area with the material's billboard setting, if enabled.
	if billboard_mode > 0:
		# Get the camera.
		var camera := get_viewport().get_camera_3d()
		# Look in the same direction as the camera.
		var look := camera.to_global(Vector3(0, 0, -100)) - camera.global_transform.origin
		look = node_area.position + look

		# Y-Billboard: Lock Y rotation, but gives bad results if the camera is tilted.
		if billboard_mode == 2:
			look = Vector3(look.x, 0, look.z)

		node_area.look_at(look, Vector3.UP)

		# Rotate in the Z axis to compensate camera tilt.
		node_area.rotate_object_local(Vector3.BACK, camera.rotation.z)

#region mouse inputs

# mouse entered and exited
func _mouse_entered_area() -> void:
	#print("entered")
	is_mouse_inside = true
	
	# Notify the viewport that the mouse is now hovering it.
	node_viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)

func _mouse_exited_area() -> void:
	#print("exited")
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
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5
		
		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos2D.x *= node_viewport.size.x
		event_pos2D.y *= node_viewport.size.y
		
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
