class_name TestComponent extends Component

@export var points = 200

@onready var points_label = $StaticBody3D/PointsLabel

func _ready() -> void:
	points_label.text = str(points)

func trigger():
	super.trigger()
	score_manager.add_points(points)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Ball:
		return
	
	trigger()
