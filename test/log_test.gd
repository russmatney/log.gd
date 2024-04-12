extends GdUnitTestSuite

## strings ##########################################

func test_log_strings_and_string_names():
	var val = Log.to_pretty("Special")
	assert_that(val).is_equal("[color=pink]Special[/color]")

	val = Log.to_pretty(&"Special")
	assert_that(val).is_equal("[color=orange]&[/color]\"Special\"")

## numbers ##########################################

func test_log_ints():
	var val = Log.to_pretty(1)
	assert_that(val).is_equal("[color=green]1[/color]")

func test_log_floats():
	var val = Log.to_pretty(1.4)
	assert_that(val).is_equal("[color=green]1.4[/color]")

## collections ##########################################

func test_log_array():
	var val = Log.to_pretty([1, 2, 3])
	assert_that(val).is_equal(
		"[color=red][ [/color][color=green]1[/color][color=red], [/color][color=green]2[/color][color=red], [/color][color=green]3[/color][color=red] ][/color]")

func test_log_vector():
	var val = Log.to_pretty(Vector2(1, 2))
	assert_that(val).is_equal("[color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red])[/color]")

func test_log_dictionary():
	var val = Log.to_pretty({some="val", another=2})
	assert_that(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]val[/color][color=red], [/color][color=magenta]\"another\"[/color]: [color=green]2[/color][color=red] }[/color]")

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
	assert_that(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"val\"[/color]: [color=red]([/color][color=green]1[/color][color=red],[/color][color=green]2[/color][color=red])[/color][color=red], [/color][color=magenta]\"id\"[/color]: [color=green]%s[/color][color=red] }[/color]"
		% str(id))
