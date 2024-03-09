extends GdUnitTestSuite

var regex
var regex2

func before():
	regex = RegEx.new()
	regex.compile("\\[([^\\\\]\\\\]*)\\]")

## helpers ##########################################

func bb_sub(val):
	# val = regex.sub(val, "<1>", true)
	return val

func to_test_input(val):
	return bb_sub(Log.to_printable(val))

func debug_output(val):
	print(val)
	# for x in val:
	# 	printraw(x)

## tests ##########################################

func test_log_params():
	var val = to_test_input([1, 2, 3])
	debug_output(val)
	assert_that(val).is_equal("1 2 3")

func test_log_array():
	var val = to_test_input([[1, 2, 3]])
	debug_output(val)
	assert_that(val).is_equal("[color=red][ [/color]1[color=red], [/color]2[color=red], [/color]3[color=red] ][/color]")

func test_log_vector():
	var val = to_test_input([Vector2(1, 2)])
	debug_output(val)
	assert_that(val).is_equal("([color=purple]1[/color],[color=purple]2[/color])")
