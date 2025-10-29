extends Node

@onready var score_manager = get_tree().get_first_node_in_group("ScoreManager")

var modifier_function_dictionary: Dictionary[String, String] = {
	"point_add":"trigger_point_add",
	"mult_add":"trigger_mult_add",
}

var modifier_effect_color: Dictionary[String, Color] = {
	"point_add":Color.GREEN,
	"mult_add":Color.RED,
}

func get_effect_color(effect: String) -> Color:
	# check that effect is real
	if !modifier_effect_color.has(effect):
		print("global_modifiers.gd: color effect doesn't exist in dictionary! effect: ", effect)
		return Color.WHITE
	
	return modifier_effect_color[effect]

func trigger(effect: String):
	#print("global_modifiers.gd: effect triggered: ", effect)
	# check that the trigger is real
	if !modifier_function_dictionary.has(effect):
		print("global_modifiers.gd: triggered effect doesn't exist in dictionary! effect: ", effect)
		return
	
	# call the method linked to the effect
	Callable(self, modifier_function_dictionary[effect]).call()

func trigger_point_add():
	var mult_to_add = 300
	score_manager.add_points(mult_to_add)

func trigger_mult_add():
	var mult_to_add = 10
	score_manager.add_mult(mult_to_add)
