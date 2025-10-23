class_name ItemChips extends Item

func _ready() -> void:
	is_active = true

func _process(delta: float) -> void:
	if is_active and Input.is_action_just_pressed("DEBUG_add_chips"):
		score_manager._on_add_chips(1)
