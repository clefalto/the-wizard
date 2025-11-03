extends RigidBody3D

func _ready():
	pass

func get_collision_normal(body_with: PhysicsBody3D) -> Vector3:
	var state := PhysicsServer3D.body_get_direct_state(self.get_rid())
	var contacts = state.get_contact_count()
	var contact_idx = -1
	for i in range(contacts):
		if state.get_contact_collider(i) == body_with.get_rid():
			contact_idx = i
	
	if contact_idx != -1:
		return state.get_contact_local_normal(contact_idx)
	else: return Vector3.ZERO
