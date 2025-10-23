extends Node3D

@export var activation_action: String
@export var max_flip_angle := 90.0
@export var flip_speed := 1000.0
@export var settle_speed := 500.0

enum FlipperSide {left, right}
@export var flip_side: FlipperSide

@onready var initial_rotation_degrees: float = rotation_degrees.y

var flip_pressed := false

func _unhandled_input(event: InputEvent):
	if event is InputEventKey:
		if event.is_action_pressed(activation_action):
			flip_pressed = true
		if event.is_action_released(activation_action):
			flip_pressed = false

func _process(delta: float):
	var flip_direction = 1 if flip_side == FlipperSide.left else -1
	if flip_pressed:
		#self.rotation_degrees.y = clampf(self.rotation_degrees.y + delta * flip_speed, initial_rotation_degrees - max_flip_angle, initial_rotation_degrees + max_flip_angle)
		self.rotation_degrees.y = move_toward(self.rotation_degrees.y, initial_rotation_degrees + flip_direction * max_flip_angle, delta * flip_speed)
	else: # settle
		#$AnimatableBody2D.constant_angular_velocity = 0
		self.rotation_degrees.y = move_toward(self.rotation_degrees.y, initial_rotation_degrees, delta * settle_speed)
		#self.rotation_degrees.y = clampf(self.rotation_degrees.y - delta * settle_speed, initial_rotation_degrees, -max_flip_angle)
