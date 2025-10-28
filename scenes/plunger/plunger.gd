extends Node3D

var mouse_hovering: bool = false
var allow_plunge: bool = false

@export var ball_spawn_point: Node3D
@export var ball_scene: PackedScene
@export var plunge_force: float

@onready var label := $Label3D
# i don't like having this reference here but this is perhaps the easiest way to keep track of the
# number of balls that we have so that we can stop the player from plunging too close to the sun
# unless we want to run all plunge requests through the ball manager? idk
@onready var ball_manager: Node = get_tree().get_first_node_in_group("BallManager")


func _ready():
	label.visible = false

func plunge(force: bool = false):
	if not force:
		if not allow_plunge:
			print("cannot plunge right now")
			return
		elif ball_manager.balls_remaining <= 0:
			print("no more balls! not plunging!")
			return
		
	
	ball_manager.use_ball()
	var ball_instance = ball_scene.instantiate()
	ball_instance.position = ball_spawn_point.position
	get_tree().root.add_child(ball_instance)
	ball_instance.apply_central_impulse(Vector3(0.0, 0.0, plunge_force))
	allow_plunge = false

func _input(event: InputEvent):
	if event.is_action_pressed("DEBUG_spawn_ball"):
		var force_plunge := true
		plunge(force_plunge)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			plunge()


func _on_area_3d_mouse_entered() -> void:
	mouse_hovering = true
	label.visible = true


func _on_area_3d_mouse_exited() -> void:
	mouse_hovering = false
	label.visible = false
