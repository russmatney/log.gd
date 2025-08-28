extends GdUnitTestSuite

func before_test() -> void:
	Log.config = {}
	Log.is_config_setup = false

## null ##########################################

func test_null() -> void:
	var val: String = Log.to_pretty(null)
	assert_str(val).is_equal("[color=pink]<null>[/color]")

## bool ##########################################

func test_bool() -> void:
	var val: String = Log.to_pretty(true)
	assert_str(val).is_equal("[color=pink]true[/color]")

	val = Log.to_pretty(false)
	assert_str(val).is_equal("[color=pink]false[/color]")

## strings ##########################################

func test_log_strings() -> void:
	var val: String = Log.to_pretty("Special")
	assert_str(val).is_equal("[color=pink]Special[/color]")

func test_log_string_names() -> void:
	var val: String = Log.to_pretty(&"Special")
	assert_str(val).is_equal("[color=orange]&[/color]\"Special\"")

func test_node_paths() -> void:
	var np: NodePath = NodePath("Some/Path/To/A/Node")
	var val: String = Log.to_pretty(np)
	assert_str(val).is_equal("[color=orange]^[/color]\"Some/Path/To/A/Node\"")

func test_already_colorized_string() -> void:
	var val: String = Log.to_pretty("[color=blue]Something[/color]")
	assert_str(val).is_equal("[color=blue]Something[/color]")

## color ##########################################

func test_color() -> void:
	# test for printing colors (Color.new(0, 0, 0, 0)), not log.gd color nuances
	pass

## numbers ##########################################

func test_log_ints() -> void:
	var val: String = Log.to_pretty(1)
	assert_str(val).is_equal("[color=green]1[/color]")

func test_log_floats() -> void:
	var val: String = Log.to_pretty(3.14)
	assert_str(val).is_equal("[color=green]3.14[/color]")

# TYPE_MAX

## vectors ###############################################

func test_log_vector2() -> void:
	var val: String = Log.to_pretty(Vector2(1, 2))
	assert_str(val).is_equal("[color=red]([/color][color=green]1.0[/color][color=red],[/color][color=green]2.0[/color][color=red])[/color]")

func test_log_vector2i() -> void:
	var val: String = Log.to_pretty(Vector2i(1, 2))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red])[/color]"
		)

func test_log_vector3() -> void:
	var val: String = Log.to_pretty(Vector3(1, 2, 3))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1.0[/color][color=red],[/color][color=green]2.0[/color][color=red],[/color][color=green]3.0[/color][color=red])[/color]"
		)

func test_log_vector3i() -> void:
	var val: String = Log.to_pretty(Vector3i(1, 2, 3))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red],[/color][color=green]3[/color][color=red])[/color]"
		)

func test_log_vector4() -> void:
	var val: String = Log.to_pretty(Vector4(1, 2, 3, 4))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1.0[/color][color=red],[/color][color=green]2.0[/color][color=red],[/color][color=green]3.0[/color][color=red],[/color][color=green]4.0[/color][color=red])[/color]"
		)

func test_log_vector4i() -> void:
	var val: String = Log.to_pretty(Vector4i(1, 2, 3, 4))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red],[/color][color=green]3[/color][color=red],[/color][color=green]4[/color][color=red])[/color]"
		)

## rect ###############################################

func test_rect() -> void:
	# TODO
	pass

func test_rect2i() -> void:
	# TODO
	pass

## transform ###############################################

func test_transform2d() -> void:
	# TODO
	pass

func test_transform3d() -> void:
	# TODO
	pass

## plane ##########################################
## quaternion ##########################################
## aabb ##########################################
## basis ##########################################
## projection ##########################################

## arrays ##########################################

func test_log_array() -> void:
	var val: String = Log.to_pretty([1, 2, 3])
	assert_str(val).is_equal(
		"[color=red][ [/color][color=green]1[/color][color=red], [/color][color=green]2[/color][color=red], [/color][color=green]3[/color][color=red] ][/color]")

# TYPE_PACKED_STRING_ARRAY
func test_log_packed_string_array() -> void:
	var packedStrArray: PackedStringArray = PackedStringArray(["hi", "there"])
	var val: String = Log.to_pretty(packedStrArray)
	assert_str(val).is_equal(
		"[color=red][ [/color][color=pink]hi[/color][color=red], [/color][color=pink]there[/color][color=red] ][/color]")

# TYPE_PACKED_BYTE_ARRAY
# TYPE_PACKED_INT32_ARRAY
# TYPE_PACKED_INT64_ARRAY
# TYPE_PACKED_FLOAT32_ARRAY
# TYPE_PACKED_FLOAT64_ARRAY
# TYPE_PACKED_VECTOR2_ARRAY
# TYPE_PACKED_VECTOR3_ARRAY
# TYPE_PACKED_COLOR_ARRAY

## dictionaries ##########################################

func test_log_dictionary() -> void:
	var val: String = Log.to_pretty({some="val", another=2}, {disable_colors=true})
	# assert_str(val).is_equal(
	# 	"[color=red]{ [/color][color=orange]\"some\"[/color]: [color=pink]val[/color][color=red], [/color][color=orange]\"another\"[/color]: [color=green]2[/color][color=red] }[/color]"
	# 	)
	assert_str(val).is_equal("{ \"some\": val, \"another\": 2 }")

func test_array_of_dictionaries() -> void:
	var val: String = Log.to_pretty([{some="val"},{some="another"}], {disable_colors=true})
	# assert_str(val).is_equal(
	# 	"[color=red][ [/color][color=blue]{ [/color][color=cyan]\"some\"[/color]: [color=pink]val[/color][color=blue] }[/color][color=red], [/color][color=blue]{ [/color][color=cyan]\"some\"[/color]: [color=pink]another[/color][color=blue] }[/color][color=red] ][/color]"
	# 	)
	assert_str(val).is_equal("[ { \"some\": val }, { \"some\": another } ]")

func test_array_of_dictionaries_with_newlines() -> void:
	var val: String = Log.to_pretty([{some="val"},{some="another"}], {newlines=true, disable_colors=true})
	# assert_str(val).is_equal(
	# 	"[color=red][ [/color][color=blue]{ [/color][color=cyan]\"some\"[/color]: [color=pink]val[/color][color=blue] }[/color][color=red], [/color][color=blue]{ [/color][color=cyan]\"some\"[/color]: [color=pink]another[/color][color=blue] }[/color][color=red] ][/color]"
	# 	)
	assert_str(val).is_equal("[ { \"some\": val }, { \"some\": another } ]")

func test_nested_dictionaries_no_newlines() -> void:
	var val: Variant = {one={some="val", foo="bar"}, two={some="another", vals="each"}}
	var s: String = Log.to_pretty(val, {newlines=false, disable_colors=true})
	# assert_str(s).is_equal(
	# 	"[color=red]{ [/color][color=orange]\"one\"[/color]: [color=blue]{ [/color][color=cyan]\"some\"[/color]: [color=pink]val[/color][color=red], [/color][color=cyan]\"foo\"[/color]: [color=pink]bar[/color][color=blue] }[/color][color=red], [/color][color=orange]\"two\"[/color]: [color=blue]{ [/color][color=cyan]\"some\"[/color]: [color=pink]another[/color][color=red], [/color][color=cyan]\"vals\"[/color]: [color=pink]each[/color][color=blue] }[/color][color=red] }[/color]"
	# 	)
	assert_str(s).is_equal(
		"{ \"one\": { \"some\": val, \"foo\": bar }, \"two\": { \"some\": another, \"vals\": each } }"
		)

# func test_nested_dictionaries() -> void:
# 	var val: Variant = {one={some="val", foo="bar"}, two={some="another", vals="each"}}
# 	var s: String = Log.to_pretty(val, {newlines=true, disable_colors=true})
# 	# assert_str(s).is_equal(
# 	# 	"[color=red]{ [/color]
# 	# [color=orange]\"one\"[/color]: [color=blue]{ [/color]
# 	# 	[color=cyan]\"some\"[/color]: [color=pink]val[/color][color=red], [/color]
# 	# 	[color=cyan]\"foo\"[/color]: [color=pink]bar[/color][color=blue] }[/color][color=red], [/color]
# 	# [color=orange]\"two\"[/color]: [color=blue]{ [/color]
# 	# 	[color=cyan]\"some\"[/color]: [color=pink]another[/color][color=red], [/color]
# 	# 	[color=cyan]\"vals\"[/color]: [color=pink]each[/color][color=blue] }[/color][color=red] }[/color]"
# 	# 	)
# 	assert_str(s).is_equal(
# 		"{
# 	\"one\": {
# 		\"some\": val,
# 		\"foo\": bar },
# 	\"two\": {
# 		\"some\": another,
# 		\"vals\": each } }")

# func test_indentation_across_nuanced_nesting() -> void:
# 	var val: Variant = {
# 		zero=[
# 			{name="Fred Flintstone", home="bedrock"},
# 			{name="Barney Rubble"},
# 			{name="Dino Spimony", friends=[{name="Arnold", has_a="cool room"}]},
# 			],
# 		one={
# 			some="val",
# 			foo="bar",
# 			nested={dict="tionary", nd="such"}
# 			},
# 		two=3,
# 		three=[1,2,3,4],
# 		four={
# 			some="another",
# 			vals="each"
# 			}
# 		}

# 	var s: String = Log.to_pretty(val, {newlines=true})

# 	assert_str(s).is_equal(
# 		"[color=red]{ [/color]
# 	[color=orange]\"zero\"[/color]: [color=blue][ [/color]
# 	[color=green]{ [/color]
# 		[color=magenta]\"name\"[/color]: [color=pink]Fred Flintstone[/color][color=red], [/color]
# 		[color=magenta]\"home\"[/color]: [color=pink]bedrock[/color][color=green] }[/color][color=red], [/color]
# 	[color=green]{ [/color][color=magenta]\"name\"[/color]: [color=pink]Barney Rubble[/color][color=green] }[/color][color=red], [/color]
# 	[color=green]{ [/color]
# 		[color=magenta]\"name\"[/color]: [color=pink]Dino Spimony[/color][color=red], [/color]
# 		[color=magenta]\"friends\"[/color]: [color=pink][ [/color][color=orange]{ [/color]
# 			[color=cyan]\"name\"[/color]: [color=pink]Arnold[/color][color=red], [/color]
# 			[color=cyan]\"has_a\"[/color]: [color=pink]cool room[/color][color=orange] }[/color][color=pink] ][/color][color=green] }[/color][color=blue] ][/color][color=red], [/color]
# 	[color=orange]\"one\"[/color]: [color=blue]{ [/color]
# 		[color=cyan]\"some\"[/color]: [color=pink]val[/color][color=red], [/color]
# 		[color=cyan]\"foo\"[/color]: [color=pink]bar[/color][color=red], [/color]
# 		[color=cyan]\"nested\"[/color]: [color=green]{ [/color]
# 			[color=magenta]\"dict\"[/color]: [color=pink]tionary[/color][color=red], [/color]
# 			[color=magenta]\"nd\"[/color]: [color=pink]such[/color][color=green] }[/color][color=blue] }[/color][color=red], [/color]
# 	[color=orange]\"two\"[/color]: [color=green]3[/color][color=red], [/color]
# 	[color=orange]\"three\"[/color]: [color=blue][ [/color]
# 	[color=green]1[/color][color=red], [/color]
# 	[color=green]2[/color][color=red], [/color]
# 	[color=green]3[/color][color=red], [/color]
# 	[color=green]4[/color][color=blue] ][/color][color=red], [/color]
# 	[color=orange]\"four\"[/color]: [color=blue]{ [/color]
# 		[color=cyan]\"some\"[/color]: [color=pink]another[/color][color=red], [/color]
# 		[color=cyan]\"vals\"[/color]: [color=pink]each[/color][color=blue] }[/color][color=red] }[/color]"
# 		)


## rainbow delimiters #####################################

func test_rainbow_delimiters() -> void:
	var val: Variant = [[1, 2], [[3, 4, [5]]]]
	var s: String = Log.to_pretty(val, {newlines=false})
	assert_str(s).is_equal(
		"[color=red][ [/color][color=blue][ [/color][color=green]1[/color][color=red], [/color][color=green]2[/color][color=blue] ][/color][color=red], [/color][color=blue][ [/color][color=green][ [/color][color=green]3[/color][color=red], [/color][color=green]4[/color][color=red], [/color][color=pink][ [/color][color=green]5[/color][color=pink] ][/color][color=green] ][/color][color=blue] ][/color][color=red] ][/color]"
		)

## custom object ##########################################

class ExampleObj:
	var val: Variant
	func _init(v: Variant) -> void:
		val = v

	func to_pretty() -> Variant:
		return {val=val, id=get_instance_id()}

# func test_custom_to_pretty() -> void:
# 	var obj: ExampleObj = ExampleObj.new(Vector2(1, 2))
# 	var val: String = Log.to_pretty(obj)
# 	var id: int = obj.get_instance_id()
# 	assert_str(val).is_equal(
# 		"[color=red]{ [/color][color=orange]\"val\"[/color]: [color=blue]([/color][color=green]1.0[/color][color=red],[/color][color=green]2.0[/color][color=blue])[/color][color=red], [/color][color=orange]\"id\"[/color]: [color=green]%s[/color][color=red] }[/color]"
# 		% str(id))

# TODO class_name

## refcounted ##########################################
## packedscene ##########################################
## rid ##########################################
## callables ##########################################
## signals ##########################################

## custom resource ##########################################

func test_custom_resource() -> void:
	var tp: TestPlayer = TestPlayer.new()
	tp.name = "Hanz"
	tp.level = 3
	tp.role = TestPlayer.Role.Tank

	var val: String = Log.to_pretty(tp)
	assert_str(val).is_equal(
		"[color=magenta]TestPlayer.gd[/color]"
		)

# func test_custom_resource_register_overwrite() -> void:
# 	var tp: TestPlayer = TestPlayer.new()
# 	tp.name = "Hanz"
# 	tp.level = 3
# 	tp.role = TestPlayer.Role.Tank

# 	Log.register_type_overwrite(tp.get_class(), func(msg: Variant) -> Variant:
# 		return {name=msg.name, level=msg.level})

# 	var val: String = Log.to_pretty(tp)
# 	assert_str(val).is_equal(
# 		"[color=red]{ [/color][color=orange]\"name\"[/color]: [color=pink]Hanz[/color][color=red], [/color][color=orange]\"level\"[/color]: [color=green]3[/color][color=red] }[/color]"
# 		)

## color schemes ##########################################

# func test_termsafe_toggling() -> void:
# 	Log.set_colors_termsafe()
# 	var val: String = Log.to_pretty(null)
# 	assert_str(val).is_equal("[color=pink]<null>[/color]")

# 	Log.set_colors_pretty()
# 	val = Log.to_pretty(null)
# 	assert_str(val).is_equal("[color=coral]<null>[/color]")

# 	Log.set_colors_termsafe()
# 	val = Log.to_pretty(null)
# 	assert_str(val).is_equal("[color=pink]<null>[/color]")

# func test_color_overwriting() -> void:
# 	var val: String = Log.to_pretty(null, {color_theme={TYPE_NIL: "red"}})
# 	assert_str(val).is_equal("[color=red]<null>[/color]")

# 	# does not clear other colors
# 	val = Log.to_pretty(1, {color_theme={TYPE_NIL: "red"}})
# 	assert_str(val).is_equal("[color=green]1[/color]")

func test_disable_colors_to_pretty() -> void:
	assert_str(Log.to_pretty(1)).is_equal("[color=green]1[/color]")
	assert_str(Log.to_pretty(1, {disable_colors=true})).is_equal("1")

func test_disable_colors_via_config() -> void:
	assert_str(Log.to_pretty(1)).is_equal("[color=green]1[/color]")

	Log.disable_colors()
	assert_str(Log.to_pretty(1)).is_equal("1")

	Log.enable_colors()
	assert_str(Log.to_pretty(1)).is_equal("[color=green]1[/color]")

func test_disable_newline_to_pretty() -> void:
	const INPUT: Dictionary = {"one": 1, "two": 2}
	const OUTPUT_WITH_NEWLINES: String = "{ \n\t\"one\": 1, \n\t\"two\": 2 }"
	const OUTPUT_WITHOUT_NEWLINES: String = "{ \"one\": 1, \"two\": 2 }"

	assert_str(Log.to_pretty(INPUT, {disable_colors=true, newlines=true})).is_equal(OUTPUT_WITH_NEWLINES)
	assert_str(Log.to_pretty(INPUT, {disable_colors=true, newlines=false})).is_equal(OUTPUT_WITHOUT_NEWLINES)


func test_disable_newline_via_config() -> void:
	const INPUT: Dictionary = {"one": 1, "two": 2}
	const OUTPUT_WITH_NEWLINES: String = "{ \n\t\"one\": 1, \n\t\"two\": 2 }"
	const OUTPUT_WITHOUT_NEWLINES: String = "{ \"one\": 1, \"two\": 2 }"

	Log.disable_colors()
	Log.enable_newlines()
	assert_str(Log.to_pretty(INPUT)).is_equal(OUTPUT_WITH_NEWLINES)

	Log.disable_newlines()
	assert_str(Log.to_pretty(INPUT)).is_equal(OUTPUT_WITHOUT_NEWLINES)

	Log.enable_newlines()
	assert_str(Log.to_pretty(INPUT)).is_equal(OUTPUT_WITH_NEWLINES)

func test_newline_max_depth_to_pretty() -> void:
	const INPUT: Dictionary = {"one": 1, "two": {"three": 3, "four": 4}}
	const OUTPUT_DEPTH_0: String = "{ \"one\": 1, \"two\": { \"three\": 3, \"four\": 4 } }"
	const OUTPUT_DEPTH_1: String = "{ \n\t\"one\": 1, \n\t\"two\": { \"three\": 3, \"four\": 4 } }"
	const OUTPUT_DEPTH_2: String = "{ \n\t\"one\": 1, \n\t\"two\": { \n\t\t\"three\": 3, \n\t\t\"four\": 4 } }"

	assert_str(Log.to_pretty(INPUT, {disable_colors=true, newlines=true, newline_max_depth=0})).is_equal(OUTPUT_DEPTH_0)
	assert_str(Log.to_pretty(INPUT, {disable_colors=true, newlines=true, newline_max_depth=1})).is_equal(OUTPUT_DEPTH_1)
	assert_str(Log.to_pretty(INPUT, {disable_colors=true, newlines=true, newline_max_depth=2})).is_equal(OUTPUT_DEPTH_2)


func test_newline_max_depth_via_config() -> void:
	const INPUT: Dictionary = {"one": 1, "two": {"three": 3, "four": 4}}
	const OUTPUT_DEPTH_0: String = "{ \"one\": 1, \"two\": { \"three\": 3, \"four\": 4 } }"
	const OUTPUT_DEPTH_1: String = "{ \n\t\"one\": 1, \n\t\"two\": { \"three\": 3, \"four\": 4 } }"
	const OUTPUT_DEPTH_2: String = "{ \n\t\"one\": 1, \n\t\"two\": { \n\t\t\"three\": 3, \n\t\t\"four\": 4 } }"

	Log.disable_colors()
	Log.enable_newlines()

	Log.set_newline_max_depth(0)
	assert_str(Log.to_pretty(INPUT)).is_equal(OUTPUT_DEPTH_0)

	Log.set_newline_max_depth(1)
	assert_str(Log.to_pretty(INPUT)).is_equal(OUTPUT_DEPTH_1)

	Log.set_newline_max_depth(2)
	assert_str(Log.to_pretty(INPUT)).is_equal(OUTPUT_DEPTH_2)
