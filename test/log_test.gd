extends GdUnitTestSuite

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
	var val: String = Log.to_pretty({some="val", another=2})
	assert_str(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]val[/color][color=red], [/color][color=magenta]\"another\"[/color]: [color=green]2[/color][color=red] }[/color]")

func test_array_of_dictionaries() -> void:
	var val: String = Log.to_pretty([{some="val"},{some="another"}])
	assert_str(val).is_equal(
		"[color=red][ [/color][color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]val[/color][color=red] }[/color][color=red], [/color][color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]another[/color][color=red] }[/color][color=red] ][/color]"
		)

func test_array_of_dictionaries_with_newlines() -> void:
	var val: String = Log.to_pretty([{some="val"},{some="another"}], {newlines=true})
	assert_str(val).is_equal(
		"[color=red][ [/color][color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]val[/color][color=red] }[/color][color=red], [/color][color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]another[/color][color=red] }[/color][color=red] ][/color]"
		)

func test_nested_dictionaries() -> void:
	var val: Variant = {one={some="val", foo="bar"}, two={some="another", vals="each"}}
	var s: String = Log.to_pretty(val, {newlines=true})
	print(s)
	Log.prn(val)
	# TODO find a more reasonable way to assert on this
	# assert_str(s).is_equal(
	# 	"[color=red]{ [/color]\n<TAB><LF><TAB><LF><TAB>[ color=magenta]\"one\": { <LF><TAB><TAB>\"some\": val, <LF><TAB><TAB>\"foo\": bar[/color] }, <LF><TAB><LF><TAB><LF><TAB>\"two\": { <LF><TAB><TAB><TAB><TAB><LF><TAB><TAB>\"some\": anotherred], <LF><TAB><TAB><TAB><TAB><LF><TAB><TAB>\"vals\": each[color=red] ][/color] } }]}"
	# 	)

## rainbow delimiters #####################################

func test_rainbow_delimiters() -> void:
	print_rich("[lb] hi [rb]")
	var val: Variant = [[1, 2], [[3, 4, [5]]]]
	var s: String = Log.to_pretty(val, {newlines=false})
	print(s)
	Log.pr(val)
	assert_str(val).is_equal(
		"[color=red]([/color][color=red]|[/color] [color=blue]([/color][color=blue]|[/color] [color=green]1[/color][color=red], [/color][color=green]2[/color] [color=blue]|[/color][color=blue])[/color][color=red], [/color][color=blue]([/color][color=blue]|[/color] [color=green]([/color][color=green]|[/color] [color=green]3[/color][color=red], [/color][color=green]4[/color][color=red], [/color][color=pink]([/color][color=pink]|[/color] [color=green]5[/color] [color=pink]|[/color][color=pink])[/color] [color=green]|[/color][color=green])[/color] [color=blue]|[/color][color=blue])[/color] [color=red]|[/color][color=red])[/color]"
		)

## custom object ##########################################

class ExampleObj:
	var val: Variant
	func _init(v: Variant) -> void:
		val = v

	func to_pretty() -> Variant:
		return {val=val, id=get_instance_id()}

func test_custom_to_pretty() -> void:
	var obj: ExampleObj = ExampleObj.new(Vector2(1, 2))
	var val: String = Log.to_pretty(obj)
	var id: int = obj.get_instance_id()
	assert_str(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"val\"[/color]: [color=red]([/color][color=green]1.0[/color][color=red],[/color][color=green]2.0[/color][color=red])[/color][color=red], [/color][color=magenta]\"id\"[/color]: [color=green]%s[/color][color=red] }[/color]"
		% str(id))

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

func test_custom_resource_register_overwrite() -> void:
	var tp: TestPlayer = TestPlayer.new()
	tp.name = "Hanz"
	tp.level = 3
	tp.role = TestPlayer.Role.Tank

	Log.register_type_overwrite(tp.get_class(), func(msg: Variant) -> Variant:
		return {name=msg.name, level=msg.level})

	var val: String = Log.to_pretty(tp)
	assert_str(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"name\"[/color]: [color=pink]Hanz[/color][color=red], [/color][color=magenta]\"level\"[/color]: [color=green]3[/color][color=red] }[/color]"
		)

## color schemes ##########################################

func test_null_alt_colors() -> void:
	Log.set_colors_termsafe()
	var val: String = Log.to_pretty(null)
	assert_str(val).is_equal("[color=pink]<null>[/color]")

	Log.set_colors_pretty()
	val = Log.to_pretty(null)
	assert_str(val).is_equal("[color=coral]<null>[/color]")

	Log.set_colors_termsafe()
	val = Log.to_pretty(null)
	assert_str(val).is_equal("[color=pink]<null>[/color]")

func test_color_overwriting() -> void:
	var val: String = Log.to_pretty(null, {color_theme={TYPE_NIL: "red"}})
	assert_str(val).is_equal("[color=red]<null>[/color]")

	# does not clear other colors
	val = Log.to_pretty(1, {color_theme={TYPE_NIL: "red"}})
	assert_str(val).is_equal("[color=green]1[/color]")

func test_color_scheme_overwriting() -> void:
	var val: String = Log.to_pretty(null)
	assert_str(val).is_equal("[color=pink]<null>[/color]")

	Log.merge_theme_overwrites({TYPE_NIL: "red"})

	val = Log.to_pretty(null)
	assert_str(val).is_equal("[color=red]<null>[/color]")

	# does not clear other colors
	val = Log.to_pretty(1)
	assert_str(val).is_equal("[color=green]1[/color]")

	# reset colors
	Log.set_colors_termsafe()
	Log.clear_theme_overwrites()

func test_disable_colors_to_pretty() -> void:
	assert_str(Log.to_pretty(1)).is_equal("[color=green]1[/color]")
	assert_str(Log.to_pretty(1, {disable_colors=true})).is_equal("1")

func test_disable_colors_via_config() -> void:
	assert_str(Log.to_pretty(1)).is_equal("[color=green]1[/color]")

	Log.disable_colors()
	assert_str(Log.to_pretty(1)).is_equal("1")

	Log.enable_colors()
	assert_str(Log.to_pretty(1)).is_equal("[color=green]1[/color]")
