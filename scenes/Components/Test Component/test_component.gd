class_name TestComponent extends Component

@export var points = 200

@onready var points_label = $TestBumper/PointsLabel

func _ready() -> void:
	super._ready()
	points_label.text = str(points)

func trigger():
	super.trigger()
	score_manager.add_points(points)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Ball:
		return
	
	trigger()
