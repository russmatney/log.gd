extends GdUnitTestSuite

func test_log():
	var val = Log.to_printable([1, 2, 3])

	assert_that(val).is_equal("[1, 2, 3]")
