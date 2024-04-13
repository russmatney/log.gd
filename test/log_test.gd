extends GdUnitTestSuite

## null ##########################################

func test_null():
	var val = Log.to_pretty(null)
	assert_str(val).is_equal("[color=pink]<null>[/color]")

## bool ##########################################

func test_bool():
	var val = Log.to_pretty(true)
	assert_str(val).is_equal("[color=pink]true[/color]")

	val = Log.to_pretty(false)
	assert_str(val).is_equal("[color=pink]false[/color]")

## strings ##########################################

func test_log_strings():
	var val = Log.to_pretty("Special")
	assert_str(val).is_equal("[color=pink]Special[/color]")

func test_log_string_names():
	var val = Log.to_pretty(&"Special")
	assert_str(val).is_equal("[color=orange]&[/color]\"Special\"")

func test_node_paths():
	var np = NodePath("Some/Path/To/A/Node")
	var val = Log.to_pretty(np)
	assert_str(val).is_equal("[color=orange]^[/color]\"Some/Path/To/A/Node\"")

## color ##########################################

func test_color():
	# TODO
	pass

## numbers ##########################################

func test_log_ints():
	var val = Log.to_pretty(1)
	assert_str(val).is_equal("[color=green]1[/color]")

func test_log_floats():
	var val = Log.to_pretty(3.14)
	assert_str(val).is_equal("[color=green]3.14[/color]")

# TYPE_MAX

## vectors ###############################################

func test_log_vector2():
	var val = Log.to_pretty(Vector2(1, 2))
	assert_str(val).is_equal("[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red])[/color]")

func test_log_vector2i():
	var val = Log.to_pretty(Vector2i(1, 2))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red])[/color]"
		)

func test_log_vector3():
	var val = Log.to_pretty(Vector3(1, 2, 3))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red],[/color][color=green]3[/color][color=red])[/color]"
		)

func test_log_vector3i():
	var val = Log.to_pretty(Vector3i(1, 2, 3))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red],[/color][color=green]3[/color][color=red])[/color]"
		)

func test_log_vector4():
	var val = Log.to_pretty(Vector4(1, 2, 3, 4))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red],[/color][color=green]3[/color][color=red],[/color][color=green]4[/color][color=red])[/color]"
		)

func test_log_vector4i():
	var val = Log.to_pretty(Vector4i(1, 2, 3, 4))
	assert_str(val).is_equal(
		"[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red],[/color][color=green]3[/color][color=red],[/color][color=green]4[/color][color=red])[/color]"
		)

## rect ###############################################

func test_rect():
	# TODO
	pass

func test_rect2i():
	# TODO
	pass

## transform ###############################################

func test_transform2d():
	# TODO
	pass

func test_transform3d():
	# TODO
	pass

## plane ##########################################
## quaternion ##########################################
## aabb ##########################################
## basis ##########################################
## projection ##########################################

## arrays ##########################################

func test_log_array():
	var val = Log.to_pretty([1, 2, 3])
	assert_str(val).is_equal(
		"[color=red][ [/color][color=green]1[/color][color=red], [/color][color=green]2[/color][color=red], [/color][color=green]3[/color][color=red] ][/color]")

# TYPE_PACKED_STRING_ARRAY
func test_log_packed_string_array():
	var packedStrArray = PackedStringArray(["hi", "there"])
	var val = Log.to_pretty(packedStrArray)
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

func test_log_dictionary():
	var val = Log.to_pretty({some="val", another=2})
	assert_str(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]val[/color][color=red], [/color][color=magenta]\"another\"[/color]: [color=green]2[/color][color=red] }[/color]")

func test_array_of_dictionaries():
	var val = Log.to_pretty([{some="val"},{some="another"}])
	assert_str(val).is_equal(
		"[color=red][ [/color][color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]val[/color][color=red] }[/color][color=red], [/color][color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]another[/color][color=red] }[/color][color=red] ][/color]"
		)

func test_array_of_dictionaries_with_newlines():
	var val = Log.to_pretty([{some="val"},{some="another"}], {newlines=true})
	assert_str(val).is_equal(
		"[color=red][ [/color][color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]val[/color][color=red] }[/color][color=red], [/color][color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]another[/color][color=red] }[/color][color=red] ][/color]"
		)

## custom object ##########################################

class ExampleObj:
	var val
	func _init(v):
		val = v

	func to_pretty():
		return {val=val, id=get_instance_id()}

func test_custom_to_printable():
	var obj = ExampleObj.new(Vector2(1, 2))
	var val = Log.to_pretty(obj)
	var id = obj.get_instance_id()
	assert_str(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"val\"[/color]: [color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red])[/color][color=red], [/color][color=magenta]\"id\"[/color]: [color=green]%s[/color][color=red] }[/color]"
		% str(id))

# TODO class_name

## refcounted ##########################################
## packedscene ##########################################
## rid ##########################################
## callables ##########################################
## signals ##########################################

## custom resource ##########################################

func test_custom_resource():
	var tp = TestPlayer.new()
	tp.name = "Hanz"
	tp.level = 3
	tp.role = TestPlayer.Role.Tank

	var val = Log.to_pretty(tp)
	print(val)
	assert_str(val).is_equal(
		"[color=magenta]TestPlayer.gd[/color]"
		)
