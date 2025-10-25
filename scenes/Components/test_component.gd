extends Component

@export var points = 200

@onready var points_label = $PointsLabel

func _ready() -> void:
	points_label.text = str(points)
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Ball:
		return
	
	print("test_component.gd: collided with ball")
	score_manager.add_points(points)
