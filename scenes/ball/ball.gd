class_name Ball extends RigidBody3D

func _ready():
	add_constant_force(Vector3(0.2, 0, 0)) # GRAVITY

# todo probably make a collision method specifically for when this collides with other balls
# to bounce them!
# because this physics object cannot be bouncy or else... bad things happen
