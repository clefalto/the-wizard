class_name ItemBalls extends Item

func _ready() -> void:
	is_active = true

func _process(delta: float) -> void:
	if is_active and Input.is_action_just_pressed("DEBUG_add_balls"):
		score_manager.add_balls(1)
