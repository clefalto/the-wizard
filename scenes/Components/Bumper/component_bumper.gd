extends Component

@export var points_added: float = 20.0
@export var bump_force: float = 5.0
@export var ball_lockout_time: float = 0.05 # seconds between hits with the SAME BALL
@export var ball_lockout_cache_clear_time: float = 10.0

@onready var rigidbody: RigidBody3D = $MeshInstance3D/RigidBody3D

var ball_hit_dict: Dictionary[int, float] = {} 
# btw the reason we're using int instead of just the node3d here for the dictionary is because when 
# the ball is freed and you try to access it in the dictionary the engine scREAMS at you when you 
# try to erase it or access it or do anything

func _ready():
	super._ready()
	rigidbody.collided_with_ball.connect(on_rb_collided_with_ball)

func trigger():
	super.trigger()
	score_manager.add_points(points_added)

func _process(delta: float):
	var keys = ball_hit_dict.keys()
	for key in keys:
		if not is_instance_valid(instance_from_id(key)):
			ball_hit_dict.erase(key)
			continue
		ball_hit_dict[key] += delta
		
		# remove key if we haven't hit the corresponding ball in a long time
		if ball_hit_dict[key] > ball_lockout_cache_clear_time:
			ball_hit_dict.erase(key)

func on_rb_collided_with_ball(ball: Node3D, normal: Vector3):
	# check if we collided with this ball in the past `ball_lockout_time` seconds
	# using instance id's for stability reasons (just in case the ball is freed, which happens all the time)
	if not ball_hit_dict.has(ball.get_instance_id()):
		ball_hit_dict.get_or_add(ball.get_instance_id(), 0.0)
	else: 
		if ball_hit_dict[ball.get_instance_id()] > ball_lockout_time:
			ball_hit_dict[ball.get_instance_id()] = 0.0
		else:
			return
			
	# actually perform the Bumping
	ball.apply_central_impulse(-normal * bump_force)
	trigger()
