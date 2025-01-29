@tool
extends CanvasLayer

func _enter_tree() -> void:
	# print("\\033[31mHello\\033[0m")

	# Log.set_colors_pretty()
	# Log.disable_colors()

	Log.info(Log.config)

class ExampleObj:
	var val: Variant
	func _init(v: Variant) -> void:
		val = v

	func to_pretty() -> Variant:
		return {val=val, id=get_instance_id()}

@export var some_custom_types : Array[SomeResource]

func _ready() -> void:
	Log.pr("Hi there!")

	Log.pr("an array of vectors", [
		1, 2.0, Vector2(3, 4), Vector3i(1, 3, 0), Vector4(1.1, 2.2, 3.4, 4000)
		])

	Log.pr("example object", ExampleObj.new("example val"))
	Log.pr("with a Vector2i", ExampleObj.new(Vector2i(0, 6)))
	Log.prn("dictionary val", ExampleObj.new({
		nested={meta="data", nums=[1, 2.4, Vector2i(2, 4)]},
		supporting_vectors=[&"StringNames"],
		and_node_paths=NodePath("SomeNode"),
		}))

	Log.prn("custom types", some_custom_types)

	Log.pr("custom colors")
	print_rich(Log.to_pretty(1))
	print_rich(Log.to_pretty(1, {color_scheme={TYPE_INT: "purple"}}))

	Log.pr("disabled colors")
	print_rich(Log.to_pretty(1, {disable_colors=true}))

	# print("\\033[31;1;4mHello\\033[0m")
