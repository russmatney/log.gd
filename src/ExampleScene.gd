@tool
extends CanvasLayer

func _enter_tree():
	Log.set_colors_pretty()

class ExampleObj:
	var val
	func _init(v):
		val = v

	func to_printable():
		return {val=val, id=get_instance_id()}

@export var some_custom_types : Array[SomeResource]

func _ready():
	Log.pr("Hi there!", [1, 2.0, Vector2(3, 4), Vector3i(1, 3, 0), Vector4(1.1, 2.2, 3.4, 4000)])

	Log.pr("example object", ExampleObj.new("example val"))
	Log.pr("with a Vector2i", ExampleObj.new(Vector2i(0, 6)))
	Log.prn("dictionary val", ExampleObj.new({
		nested={meta="data", nums=[1, 2.4, Vector2i(2, 4)]},
		supporting_vectors=[&"StringNames"],
		and_node_paths=NodePath("SomeNode"),
		}))

	Log.prn("custom types", some_custom_types)

	Log.pr("custom colors", 1)
	print_rich(Log.to_pretty(1))
	print_rich(Log.to_pretty(1, {color_scheme={TYPE_INT: "purple"}}))
