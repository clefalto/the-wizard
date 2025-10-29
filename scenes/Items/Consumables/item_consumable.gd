class_name ItemConsumable extends Item

@export var modifier: String = "modifier"
@export var effect_color: Color = Color.WHITE

func trigger() -> void:
	#print("triggered consumable effect %s" % self)
	
	pass

func get_effect() -> String:
	return modifier

func get_effect_color() -> Color:
	return effect_color
