extends GdUnitTestSuite

## tests ##########################################

func test_log_params():
	var val = Log.to_printable([1, 2, 3])
	assert_that(val).is_equal(
		"[color=green]1[/color] [color=green]2[/color] [color=green]3[/color]")

func test_log_array():
	var val = Log.to_printable([[1, 2, 3]])
	assert_that(val).is_equal(
		"[color=red][ [/color][color=green]1[/color][color=red], [/color][color=green]2[/color][color=red], [/color][color=green]3[/color][color=red] ][/color]")

func test_log_vector():
	var val = Log.to_printable([Vector2(1, 2)])
	assert_that(val).is_equal("([color=purple]1[/color],[color=purple]2[/color])")

func test_log_dictionary():
	var val = Log.to_printable([{some="val", another=2}])
	assert_that(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"some\"[/color]: [color=pink]val[/color][color=red], [/color][color=magenta]\"another\"[/color]: [color=green]2[/color][color=red] }[/color]")

func test_log_strings_and_string_names():
	var val = Log.to_printable(["Special"])
	assert_that(val).is_equal("[color=pink]Special[/color]")


class ExampleObj:
	var val
	func _init(v):
		val = v

	func to_printable():
		return {val=val, id=get_instance_id()}


func test_custom_to_printable():
	var obj = ExampleObj.new(Vector2(1, 2))
	var val = Log.to_printable([obj])
	var id = obj.get_instance_id()
	assert_that(val).is_equal(
		"[color=red]{ [/color][color=magenta]\"val\"[/color]: ([color=purple]1[/color],[color=purple]2[/color])[color=red], [/color][color=magenta]\"id\"[/color]: [color=green]%s[/color][color=red] }[/color]" \
		% str(id))
