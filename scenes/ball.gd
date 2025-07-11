extends CharacterBody2D

func handle_gravity(delta: float):
	velocity += get_gravity() * delta

func _process(delta: float):
	pass

func _physics_process(delta: float):
	handle_gravity(delta)
	move_and_slide()
