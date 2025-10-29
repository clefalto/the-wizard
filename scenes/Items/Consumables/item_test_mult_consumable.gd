extends ItemConsumable

var mult_to_add = 50

func _ready() -> void:
	print("score manager: ", score_manager)

func trigger() -> void:
	print("score manager: ", score_manager)
	super.trigger()
	print("score manager: ", score_manager)
	score_manager.add_mult(mult_to_add)
