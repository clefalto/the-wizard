extends RigidBody3D

signal collided_with_ball(ball: Node3D, normal_direction: Vector3)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for body in get_colliding_bodies():
		if body.is_in_group("ball"):
			var norm = get_normal_with_body(body, state)
			collided_with_ball.emit(body, norm)


func get_normal_with_body(body: Node3D, state: PhysicsDirectBodyState3D) -> Vector3:
	for i in range(get_contact_count()):
		if state.get_contact_collider(i) == body.get_rid():
			return state.get_contact_local_normal(i)
	return Vector3.ZERO
