extends ItemConsumable

var points_to_add = 300

func trigger() -> void:
	super.trigger()
	score_manager.add_points(points_to_add)
