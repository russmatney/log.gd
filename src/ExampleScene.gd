@tool
class_name ExampleScene
extends CanvasLayer


## Color used in the custom color showcase
@export var custom_color: Color = Color.PURPLE

## An exported array of a custom resource
@export var some_custom_types: Array[SomeResource] = []

## A complex, deeply nested object
var example_object: ExampleObj = ExampleObj.new({
	"nested_array": {
		"meta": "data",
		"nums": [1, 2.4, Vector2i(2, 4)]
	},
	"nested_dict": {
		"two": "three",
		"four": {
			"five": "five",
			"six": "six",
		},
	},
	"supporting_vectors": [&"StringNames"],
	"and_node_paths": NodePath("SomeNode"),
})


@onready var check_button_colors: CheckButton = %CheckButtonColors
@onready var color_picker_button: ColorPickerButton = %ColorPickerButton
@onready var check_button_pretty_colors: CheckButton = %CheckButtonPrettyColors
@onready var check_button_newlines: CheckButton = %CheckButtonNewlines
@onready var spin_box_newline_max_depth: SpinBox = %SpinBoxNewlineMaxDepth
@onready var option_button_log_level: OptionButton = %OptionButtonLogLevel
@onready var check_button_warn_todo: CheckButton = %CheckButtonWarnTodo


func _ready() -> void:
	check_button_colors.set_pressed_no_signal(not Log.get_disable_colors())
	color_picker_button.color = custom_color
	check_button_pretty_colors.set_pressed_no_signal(true)
	check_button_newlines.set_pressed_no_signal(Log.get_use_newlines())
	spin_box_newline_max_depth.set_value_no_signal(Log.get_newline_max_depth())
	option_button_log_level.select(Log.get_log_level())
	check_button_warn_todo.set_pressed_no_signal(Log.get_warn_todo())


## Connected to CheckButtonColors.
func set_enable_colors(enable: bool) -> void:
	if enable:
		Log.enable_colors()
		Log.log("Enabled colors")
	else:
		Log.disable_colors()
		Log.log("Disabled colors")


## Connected to ColorPickerButton.
func set_custom_color(color: Color) -> void:
	custom_color = color


## Connected to CheckButtonPrettyColors.
func set_pretty_colors(enable: bool) -> void:
	if enable:
		Log.set_colors_pretty()
		Log.log("Pretty colors enabled")
	else:
		Log.set_colors_termsafe()
		Log.log("Term safe colors enabled")


## Connected to CheckButtonNewlines.
func set_enable_newlines(enable: bool) -> void:
	if enable:
		Log.enable_newlines()
		Log.log("Enabled newlines")
	else:
		Log.disable_newlines()
		Log.log("Disabled newlines")


## Connected to SpinBoxNewlineMaxDepth.
func set_newline_max_depth(depth: float) -> void:
	Log.set_newline_max_depth(int(depth))
	Log.log("Newline max depth: %d" % depth)


## Connected to OptionButtonLogLevel.
func set_log_level(log_level: int) -> void:
	var log_level_lookup: Array[String] = ["Debug", "Info", "Warn", "Error"]
	Log.set_log_level(log_level)
	Log.log("Log Level: %s" % log_level_lookup[log_level])


## Connected to CheckButtonWarnTodo.
func set_warn_todo(enable: bool) -> void:
	if enable:
		Log.enable_warn_todo()
		Log.log("Enabled warn todo")
	else:
		Log.disable_warn_todo()
		Log.log("Disabled warn todo")


## Easily run all Log.gd showcases.
func run_showcases() -> void:
	showcase_easy_newlines()
	showcase_log_levels()
	showcase_colors()
	showcase_ints_and_floats()
	showcase_vectors()
	showcase_strings()
	showcase_arrays()
	showcase_dictionaries()
	showcase_objects()
	showcase_known_bugs()


## A simple multi-line header to break up walls of text.
func print_header(header: String) -> void:
	print_rich(str("\n\n\t==== ", header, " ====\n"))


## Showcase [code]Log.pr()[/code], [code]Log.prn()[/code],
## [code]Log.prnn()[/code], and [code]Log.prnnn()[/code].
func showcase_easy_newlines() -> void:
	print_header("Easy Newlines with [code]Log.prn()[/code]")
	Log.pr(example_object)
	Log.blank()

	Log.prn(example_object)
	Log.blank()

	Log.prnn(example_object)
	Log.blank()

	Log.prnnn(example_object)


## Showcase all available log levels.
func showcase_log_levels() -> void:
	print_header("Levels")
	Log.log("Log.log()")
	Log.debug("Log.debug()")
	Log.info("Log.info()")
	Log.warn("Log.warn()")
	Log.todo("Log.todo()")
	Log.err("Log.err()")
	Log.error("Log.error()")


## Showcase the custom color functionality of [code]Log.to_pretty()[/code].
func showcase_colors() -> void:
	print_header("Custom Colors with [code]Log.to_pretty()[/code]")

	print("Plain ol' print()")
	print_rich(Log.to_pretty(
			"Log.gd standard colors with [code]Log.to_pretty()[/code]",
			{"color": custom_color}))
	print_rich(Log.to_pretty(
			"Custom colors with [code]Log.to_pretty()[/code]",
			{"color": custom_color}))
	print_rich(
			Log.to_pretty("Disable colors with [code]Log.to_pretty()[/code]",
			{"disable_colors": true}))


## Showcase ints and floats
func showcase_ints_and_floats() -> void:
	print_header("Ints and Floats")

	print(42, 3.14)
	Log.log(42, 3.14)
	Log.blank()

	print(1)
	Log.log(1)
	Log.blank()

	print(1.0)
	Log.log(1.0)


## Showcase the printing of Vectors, float and int
func showcase_vectors() -> void:
	print_header("Vectors")

	print(Vector2())
	Log.log(Vector2())
	Log.blank()

	print(Vector3(2.3, 1.4, 0.5))
	Log.log(Vector3(2.3, 1.4, 0.5))
	Log.blank()

	print(Vector2i.LEFT)
	Log.log(Vector2i.LEFT)
	Log.blank()

	print(Vector3i.UP)
	Log.log(Vector3i.UP)


## Showcase strings and string names
func showcase_strings() -> void:
	print_header("Strings and String Names")

	print("Hello, World!")
	Log.log("Hello, World!")
	Log.blank()

	print("Hello", &"World")
	Log.log("Hello", &"World")
	Log.blank()

	print(&"Hi there!")
	Log.log(&"Hi there!")


## Showcase mixed arrays of various nesting levels
func showcase_arrays() -> void:
	print_header("Arrays")

	var simple_array: Array = [1, 2.0, 3, 4.0]
	print(simple_array)
	Log.log(simple_array)
	Log.prn(simple_array)
	Log.blank()

	# Until Godot allows unpacking of arrays, I'm not exactly sure how to move
	# this print statement into a variable effectively.
	print(1, 2.0, [3, 4.0])
	Log.log(1, 2.0, [3, 4.0])
	Log.prn(1, 2.0, [3, 4.0])
	Log.blank()

	var nested_array: Array = [1, 2.0, [3, 4.0]]
	print(nested_array)
	Log.log(nested_array)
	Log.prn(nested_array)
	Log.blank()

	var array_with_vectors: Array = [
		1, 2.0, Vector2(3, 4), Vector3i(1, 3, 0), Vector4(1.1, 2.2, 3.4, 4000)
	]
	print(array_with_vectors)
	Log.log(array_with_vectors)
	Log.prn(array_with_vectors)


## Showcase dictionaries of various nesting levels
func showcase_dictionaries() -> void:
	print_header("Dictionaries")
	var test_dictionary: Dictionary[String, Variant] = {
		"name": "Arthur",
		"quest": "I seek the grail",
		"health": 0.7,
	}
	print(test_dictionary)
	Log.log(test_dictionary)
	Log.prn(test_dictionary)
	Log.blank()

	var nested_dictionary: Dictionary[String, Variant] = {
		"name": "Arthur",
		"quest": "I seek the grail",
		"health": 0.7,
		"inventory": {
			"slot_a": "crown",
			"slot_b": "sword",
		},
	}
	print(nested_dictionary)
	Log.log(nested_dictionary)
	Log.prn(nested_dictionary)


## Showcase a handful of different objects.
func showcase_objects() -> void:
	print_header("Objects")
	print(self)
	Log.log(self)
	Log.blank()

	print("custom types", some_custom_types)
	Log.log("custom types", some_custom_types)
	Log.blank()

	print("example object", ExampleObj.new("example val"))
	Log.log("example object", ExampleObj.new("example val"))
	Log.blank()

	print("with a Vector2i", ExampleObj.new(Vector2i(0, 6)))
	Log.log("with a Vector2i", ExampleObj.new(Vector2i(0, 6)))
	Log.blank()

	print("nested values", example_object)
	Log.log("nested values", example_object)


## Showcase any known bugs for the running version of Godot.
func showcase_known_bugs() -> void:
	var version: Dictionary = Engine.get_version_info()
	if version.major == 4 and version.minor == 4 and version.patch == 1:
		print_rich_debugging()


## Godot 4.4.1 has a [code][[/code] parsing bug - already fixed by Godot 4.5.
## [br][br]
## This method has a bunch of test prints reproducing the issue.
func print_rich_debugging() -> void:
	print_header("Known Bug: [ parsing in Godot 4.4.1")
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


## A simple object used to showcase the [code]to_pretty()[/code] implementation
## on a custom object.
class ExampleObj:
	var val: Variant

	func _init(v: Variant) -> void:
		val = v

	func to_pretty() -> Variant:
		return {
			"val": val,
			"id": get_instance_id()
		}
