extends ItemConsumable

var mult_to_add = 50

func trigger() -> void:
	super.trigger()
	score_manager.add_mult(mult_to_add)
