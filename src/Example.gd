@tool
extends CanvasLayer

class ExampleObj:
	var val
	func _init(v):
		val = v

	func to_printable():
		return {val=val, id=get_instance_id()}

func _ready():
	Log.pr("Hi there!", [1, 2.0, Vector2(3, 4)])
	Log.prn("Hi there!", [1, 2.0, Vector2(3, 4)])

	Log.prn("I'm an example object!", ExampleObj.new("example val"))
	Log.prn("I'm another, with a Vector2i val!", ExampleObj.new(Vector2i(0, 6)))
	Log.prn("I'm a third, with a dictionary val!", ExampleObj.new({
		nested={meta="data", nums=[1, 2.4, Vector2i(2, 4)]},
		supporting_vectors=[&"StringNames"],
		and_node_paths=NodePath("SomeNode"),
		}))
