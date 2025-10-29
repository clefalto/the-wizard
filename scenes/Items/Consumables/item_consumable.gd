class_name ItemConsumable extends Item

@export var modifier: String = "modifier"

func trigger():
	#print("triggered consumable effect %s" % self)
	GlobalModifiers.trigger(modifier)
