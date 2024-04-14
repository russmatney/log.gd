@tool
extends Resource
class_name SomeResource

enum Element {NONE, FIRE, WATER, WIND}

@export var name : String
@export var element : Element

func to_pretty():
	return {name=name, element=element}
