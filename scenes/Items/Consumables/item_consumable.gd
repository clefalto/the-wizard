class_name ItemConsumable extends Item

@export var modifier: String = "modifier"

func trigger() -> void:
	#print("triggered consumable effect %s" % self)
	GlobalModifiers.trigger(modifier)

func get_effect() -> String:
	return modifier

func get_effect_color() -> Color:
	return GlobalModifiers.get_effect_color(modifier)
