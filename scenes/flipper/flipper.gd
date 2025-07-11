extends Node2D


@export var activation_action: String
@export var max_flip_angle := 90.0
@export var flip_speed := 1000.0
@export var settle_speed := 500.0

@onready var static_body: StaticBody2D = $StaticBody2D
@onready var area: Area2D = $Area2D

var is_flipping := false

func _ready():
	pass

func _unhandled_input(event: InputEvent):
	if event is InputEventKey:
		if event.is_action_pressed(activation_action):
			start_flipping()

func _process(delta: float):
	if is_flipping:
		self.rotation_degrees = clampf(self.rotation_degrees - delta * flip_speed, -max_flip_angle, max_flip_angle)
		if self.rotation_degrees == -max_flip_angle:
			is_flipping = false
	else:
		self.rotation_degrees = clampf(self.rotation_degrees + delta * settle_speed, -max_flip_angle, 0.0)

func start_flipping():
	if not is_flipping: is_flipping = true
