@tool
extends CanvasLayer

func _enter_tree() -> void:
	# print("\\033[31mHello\\033[0m")

	Log.set_colors_pretty()
	# Log.disable_colors()

	# print(Log.config)
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

	run_showcase()

func print_header(header: String) -> void:
	print(str("\n\n\t====", header, "====\n\n"))

func print_and_log(v: Variant) -> void:
	print(v)
	Log.pr(v)

func run_showcase() -> void:
	print_header("SHOWCASE")

	print_header("Ints, Floats")
	print_and_log(1)
	print_and_log(1.0)
	Log.pr(0.0, 1.0, 3.14)

	print_header("Vectors")
	print_and_log(Vector2())
	print_and_log(Vector3(2.3, 1.4, 0.5))
	print_and_log(Vector2i.LEFT)
	print_and_log(Vector3i.UP)

	print_header("Strings, String Names")
	print_and_log("Hello, World!")
	print_and_log(&"Hi there!")
	Log.pr("Hello", &"World")

	print_header("Arrays")
	print_and_log([1, 2.0, 3, 4.0])
	Log.pr(1, 2.0, [3, 4.0])
	Log.prn([1, 2.0, 3, 4.0])

	print_header("Dictionaries")
	print_and_log({name="Arthur", quest="I seek the grail", health=0.7})
