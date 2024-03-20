static func expected_version(current, later_or_equal, before=""):
	var is_expected = false
	is_expected = compare_version_string(current, later_or_equal) >= 0
	if not is_expected:
		return is_expected
	
	if before.length() > 0:
		is_expected = compare_version_string(current, before) < 0
	
	return is_expected

static func compare_version_string(v1, v2):
	var v1_arr = v1.split(".")
	var v2_arr = v2.split(".")
	assert(v1_arr.size() == 3)
	assert(v2_arr.size() == 3)
	var value = 0
	for i in 3:
		var n1 = int(v1_arr[i])
		var n2 = int(v2_arr[i])
		value = compare_number(n1, n2)
		if value != 0:
			break
	return value

static func compare_number(v1, v2):
	return 0 if v1 == v2 else (1 if v1 > v2 else -1)
