extends Node3D

@export var activation_action: String
@export var max_flip_angle := 90.0
@export var flip_speed := 1000.0
@export var settle_speed := 500.0

enum FlipperSide {left, right}
@export var flip_side: FlipperSide

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
		self.rotation_degrees.y = clampf(self.rotation_degrees.y + delta * flip_speed * flip_direction, min(-max_flip_angle * flip_direction, max_flip_angle * flip_direction), max(max_flip_angle * flip_direction, -max_flip_angle * flip_direction))
	else: # settle
		#$AnimatableBody2D.constant_angular_velocity = 0
		self.rotation_degrees.y = clampf(self.rotation_degrees.y - delta * settle_speed * flip_direction, min(0.0, -max_flip_angle * flip_direction), max(0.0, -max_flip_angle * flip_direction))
