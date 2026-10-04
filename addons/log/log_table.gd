class_name LogTable
extends Object


## Returns the column width that Log.to_pretty will print.
static func item_width(item: Variant):
	# colorless and no newlines - could probably use a dedicated to_pretty_basic (or better named) variant
	var pretty_bb = Log.to_pretty(item, {newlines=false, disable_colors=true})
	return len(pretty_bb)

static func header(
	config: LogTableConfig,
	longest_values: Array[int],
) -> String:
	var header: String = ""
	for i in range(len(config.columns)):
		header += config.delimiter + _item_to_cell(
			LogTable.truncate_string(config.columns[i], config.max_length),
			longest_values[i],
			i,
			config,
		)
	header += config.delimiter + "\n" + config.delimiter
	for i in range(len(config.columns)):
		var alignment: HorizontalAlignment = _alignment_from_index(i, config)
		header += (
			":" if alignment in [
				HORIZONTAL_ALIGNMENT_LEFT,
				HORIZONTAL_ALIGNMENT_CENTER,
			] else "-"
		)
		var length: int = 1
		if config.pad_cells:
			length = max(1, min(longest_values[i], config.max_length))
		for j in range(length):
			header += "-"
		header += (
			":" if alignment in [
				HORIZONTAL_ALIGNMENT_RIGHT,
				HORIZONTAL_ALIGNMENT_CENTER,
			] else "-"
		)
		header += config.delimiter
	return header


static func body(
	config: LogTableConfig,
	longest_values: Array[int],
	data: Variant,
) -> String:
	var body: String = ""
	if typeof(data[0]) == TYPE_ARRAY:
		for item: Array in data:
			for i in range(len(item)):
				body += (
					config.delimiter
					+ _item_to_cell(item[i], longest_values[i], i, config)
				)
			body += config.delimiter + "\n"

	elif typeof(data[0]) == TYPE_DICTIONARY:
		for item: Dictionary in data:
			var item_values: Array = item.values()
			for i in range(len(item_values)):
				body += (
					config.delimiter
					+ _item_to_cell(
						item_values[i],
						longest_values[i],
						i,
						config,
					)
				)
			body += config.delimiter + "\n"

	elif typeof(data[0]) == TYPE_OBJECT:
		for item: Object in data:
			for i in range(len(config.columns)):
				body += (
					config.delimiter
					+ _item_to_cell(
						item.get(config.columns[i]),
						longest_values[i],
						i,
						config,
					)
				)
			body += config.delimiter + "\n"

	else:
		for i in range(len(data)):
			body += (
				config.delimiter
				+ _item_to_cell(data[i], longest_values[i], i, config)
			)
		body += config.delimiter + "\n"
	return body


## Truncate a string to a maximum length of [param target_length] and a default
## [param suffix] of [code]...[/code] indicating there's more to the string than
## what was printed.  The resulting string will be no longer than
## [param target_length] even when the [param suffix] is appended.
## TODO-table: Colorize truncated output.
static func truncate_string(
	input_string: String,
	target_length: int,
	suffix: String = "...",
) -> String:
	var do_suffix: bool = len(input_string) > target_length
	if not len(input_string) > target_length:
		return input_string

	input_string = input_string.substr(0, target_length - suffix.length())
	input_string += suffix
	return input_string


static func _align_string(
	in_string: String,
	padding: int,
	alignment: HorizontalAlignment,
) -> String:
	var out_string: String = in_string
	match alignment:
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT:
			for i in range(padding):
				out_string = out_string + " "
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT:
			for i in range(padding):
				out_string = " " + out_string
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER:
			var half_padding: int = padding / 2
			for i in floori(half_padding):
				out_string = out_string + " "
			for i in ceili(half_padding):
				out_string = " " + out_string
			if padding % 2:
				out_string += " "
	return out_string


static func _alignment_from_index(
	index: int,
	config: LogTableConfig,
) -> HorizontalAlignment:
	# TODO-table: make default
	var alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
	if index < len(config.column_alignment):
		alignment = config.column_alignment[index]
	return alignment


static func _item_to_cell(
	item: Variant,
	cell_length: int,
	column_index: int,
	config: LogTableConfig,
) -> String:
	var str_value: String = str(item)
	var cell: String = ""
	var len_str_value: int = len(str_value)

	match typeof(item):
		TYPE_ARRAY:
			len_str_value += 2

	if len_str_value <= config.max_length:
		cell = Log.to_pretty(item, {"newlines": false})
	else:
		cell = LogTable.truncate_string(str_value, config.max_length)

	if config.escape_delimiter:
		cell = cell.replace(config.delimiter, "\\%s" % config.delimiter)

	if config.pad_cells:
		var alignment = _alignment_from_index(column_index, config)
		cell = _align_string(
			cell,
			max(0, cell_length - len_str_value),
			alignment,
		)

	return " %s " % cell
