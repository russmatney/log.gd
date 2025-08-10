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
	Log._internal_debug("Hi there!")

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

	# print_rich_debugging()

func print_header(header: String) -> void:
	print(str("\n\n\t====", header, "====\n\n"))

func run_showcase() -> void:
	print_header("SHOWCASE")

	# ints and floats
	print_header("Ints, Floats")
	Log.pr(42, 3.14)
	print(1)
	Log.pr(1)

	print(1.0)
	Log.pr(1.0)

	# vectors
	print_header("Vectors")
	print(Vector2())
	Log.pr(Vector2())

	print(Vector3(2.3, 1.4, 0.5))
	Log.pr(Vector3(2.3, 1.4, 0.5))

	print(Vector2i.LEFT)
	Log.pr(Vector2i.LEFT)

	print(Vector3i.UP)
	Log.pr(Vector3i.UP)

	# strings
	print_header("Strings, String Names")
	Log.pr("Hello", &"World")
	print("Hello, World!")
	Log.pr("Hello, World!")
	print(&"Hi there!")
	Log.pr(&"Hi there!")

	# arrays
	print_header("Arrays")
	print([1, 2.0, 3, 4.0])
	Log.pr([1, 2.0, 3, 4.0])
	Log.pr(1, 2.0, [3, 4.0])
	# with newlines
	Log.prn([1, 2.0, 3, 4.0])

	# dictionaries
	print_header("Dictionaries")
	print({name="Arthur", quest="I seek the grail", health=0.7})
	Log.pr({name="Arthur", quest="I seek the grail", health=0.7})
	# with newlines
	Log.prn({name="Arthur", quest="I seek the grail", health=0.7})

	print_header("Objects")
	print(self)
	Log.pr(self)

	var nested_dicts: Dictionary = {
		one={two="three", four="five"},
		two={two="three", four={five="five", six="six"}},
		three={two="three", four="five"},
		}
	Log.prn(nested_dicts)
	Log.pr(nested_dicts)

# func to_pretty() -> Variant:
# 	return {name=name}

func print_rich_debugging() -> void:
	# Godot 4.4.1 has a `[` parsing bug - already fixed by Godot 4.5
	# here's a bunch of test prints reproducing the issue
	print_rich("[color=red][[/color]")
	print_rich("[lb] hi [rb]")
	print_rich("[color=red][[/color] [color=blue]1, 2[/color] [color=green]][/color]")
	print_rich("[color=red][ [color=blue]1, 2[/color] [color=green]][/color]")
	print_rich("[color=red][lb][/color] [color=blue]1, 2[/color] [color=green]][/color]")
	print_rich("[color=red][lb] [color=blue]1, 2[/color] [color=green]][/color]")
	print_rich("[color=red]/[[/color] [color=blue]1, 2[/color] [color=green]][/color]")
	print_rich("[color=red]\\[[/color] [color=blue]1, 2[/color] [color=green]][/color]")
	print_rich("[ [color=blue]1, 2[/color] [color=green]][/color]")
	print_rich("[color=red]'['[/color] [color=blue]1, 2[/color] [color=green]][/color]")
