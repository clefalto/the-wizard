extends Component

@export var points_added: float = 20.0
@export var bump_force: float = 5.0

@onready var rigidbody: RigidBody3D = $MeshInstance3D/RigidBody3D

func _ready():
	super._ready()
	rigidbody.collided_with_ball.connect(on_rb_collided_with_ball)

func trigger():
	super.trigger()
	score_manager.add_points(points_added)


func on_rb_collided_with_ball(ball: Node3D, normal: Vector3):
	ball.apply_central_impulse(-normal * bump_force)
	trigger()
