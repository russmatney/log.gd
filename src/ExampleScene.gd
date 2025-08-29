@tool
extends CanvasLayer

func _enter_tree() -> void:
	#print("\\033[31mHello\\033[0m")

	Log.set_colors_pretty()
	#Log.disable_colors()

	#Log.disable_newlines()
	#Log.enable_newlines()

	#Log.set_log_level(Log.Levels.WARN)

	#Log.disable_warn_todo()

	#print(Log.config)
	Log.info(Log.config)

class ExampleObj:
	var val: Variant
	func _init(v: Variant) -> void:
		val = v

	func to_pretty() -> Variant:
		return {val=val, id=get_instance_id()}

var example_object: ExampleObj = ExampleObj.new({
	nested_array={meta="data", nums=[1, 2.4, Vector2i(2, 4)]},
	nested_dict={two="three", four={five="five", six="six"}},
	supporting_vectors=[&"StringNames"],
	and_node_paths=NodePath("SomeNode"),
	})

var showcases: Array[Callable] = [
	showcase_easy_newlines,
	showcase_levels,
	showcase_colors,
	showcase_ints_and_floats,
	showcase_vectors,
	showcase_strings,
	showcase_arrays,
	showcase_dictionaries,
	showcase_objects,
	showcase_known_bugs,
]
var showcase_count: int = showcases.size()
var current_showcase: int = 0

@export var some_custom_types : Array[SomeResource]

func _ready() -> void:
	Log.pr("Hi there!")
	Log._internal_debug("Hi there!")

	#print("\\033[31;1;4mHello\\033[0m")

	# The default for network/limits/debugger/max_chars_per_second is too few
	# characters for some of the busier showcases to run all at once.  A few
	# awaits have been delicately sprinkled through to not flood the debugger.
	await get_tree().create_timer(1.0).timeout
	await run_showcase()

func print_header(header: String) -> void:
	print(str("\n\n\t==== ", header, " ====\n"))

func run_showcase() -> void:
	print_header("SHOWCASE")
	for showcase: Callable in showcases:
		await showcase.call()
		await get_tree().create_timer(0.1).timeout

func showcase_easy_newlines() -> void:
	print_header("Easy Newlines")
	Log.pr(example_object)
	await get_tree().create_timer(0.34).timeout
	Log.prn(example_object)
	await get_tree().create_timer(0.34).timeout
	Log.prnn(example_object)
	await get_tree().create_timer(0.34).timeout
	Log.prnnn(example_object)

func showcase_levels() -> void:
	print_header("Levels")
	Log.log("Log.log()")
	Log.debug("Log.debug()")
	Log.info("Log.info()")
	Log.warn("Log.warn()")
	Log.todo("Log.todo()")
	Log.err("Log.err()")
	Log.error("Log.error()")

func showcase_colors() -> void:
	print_header("Custom Colors")
	Log.pr("custom colors")
	print_rich(Log.to_pretty(1))
	print_rich(Log.to_pretty(1, {color_scheme={TYPE_INT: "purple"}}))

	Log.pr("disabled colors")
	print_rich(Log.to_pretty(1, {disable_colors=true}))

func showcase_ints_and_floats() -> void:
	print_header("Ints and Floats")
	print(42, 3.14)
	Log.pr(42, 3.14)

	print(1)
	Log.pr(1)

	print(1.0)
	Log.pr(1.0)

func showcase_vectors() -> void:
	print_header("Vectors")
	print(Vector2())
	Log.pr(Vector2())

	print(Vector3(2.3, 1.4, 0.5))
	Log.pr(Vector3(2.3, 1.4, 0.5))

	print(Vector2i.LEFT)
	Log.pr(Vector2i.LEFT)

	print(Vector3i.UP)
	Log.pr(Vector3i.UP)

func showcase_strings() -> void:
	print_header("Strings and String Names")
	Log.pr("Hello", &"World")
	print("Hello, World!")
	Log.pr("Hello, World!")
	print(&"Hi there!")
	Log.pr(&"Hi there!")

func showcase_arrays() -> void:
	print_header("Arrays")
	print([1, 2.0, 3, 4.0])
	Log.pr([1, 2.0, 3, 4.0])
	Log.pr(1, 2.0, [3, 4.0])
	Log.prn([1, 2.0, 3, 4.0])

	Log.pr("an array of vectors", [
		1, 2.0, Vector2(3, 4), Vector3i(1, 3, 0), Vector4(1.1, 2.2, 3.4, 4000)
		])

func showcase_dictionaries() -> void:
	print_header("Dictionaries")
	var test_dictionary: Dictionary[String, Variant] = {name="Arthur", quest="I seek the grail", health=0.7}
	print(test_dictionary)
	Log.pr(test_dictionary)
	Log.prn(test_dictionary)

func showcase_objects() -> void:
	print_header("Objects")
	print(self)
	Log.pr(self)

	Log.prn("custom types", some_custom_types)

	Log.pr("example object", ExampleObj.new("example val"))
	Log.pr("with a Vector2i", ExampleObj.new(Vector2i(0, 6)))
	Log.prn("nested values", example_object)

func showcase_known_bugs() -> void:
	print_header("Known Bugs")
	var version: Dictionary = Engine.get_version_info()
	if version.major == 4 and version.minor == 4 and version.patch == 1:
		print_rich_debugging()

func print_rich_debugging() -> void:
	# Godot 4.4.1 has a `[` parsing bug - already fixed by Godot 4.5
	# here's a bunch of test prints reproducing the issue
	print_header("[ parsing in Godot 4.4.1")
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
