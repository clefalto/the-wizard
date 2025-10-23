class_name ItemMult extends Item

func _ready() -> void:
	is_active = true

func _process(delta: float) -> void:
	if is_active and Input.is_action_just_pressed("DEBUG_add_mult"):
		score_manager._on_add_mult(1)
