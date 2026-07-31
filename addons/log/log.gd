@tool
class_name Log
extends Object
## Log.gd - colorized pretty printing functions
##
## [code]Log.pr(...)[/code] and [code]Log.prn(...)[/code] are drop-in replacements for [code]print(...)[/code].
##
## [br][br]
## You can also [code]Log.warn(...)[/code] or [code]Log.error(...)[/code] to both print and push_warn/push_error.
##
## [br][br]
## Custom object output is supported by implementing [code]to_pretty()[/code] on the object.
##
## [br][br]
## For objects you don't own (built-ins or addons you don't want to edit),
## there is a [code]register_type_overwrite(key, handler)[/code] helper.
##
## [br][br]
## You can find up-to-date docs and examples in the Log.gd repo and docs site:
## [br]
## - https://github.com/russmatney/log.gd
## [br]
## - https://russmatney.github.io/log.gd


enum Levels {
	DEBUG,
	INFO,
	WARN,
	ERROR
}

enum TimestampTypes {
	UNIX,
	TICKS_MSEC,
	TICKS_USEC,
	HUMAN_12HR,
	HUMAN_24HR
}


const LOGGER_NAME: String = "Log.gd"


static var _core: LogCore = LogCore.new(LOGGER_NAME)


###################
# Applying Colors #
###################

static func get_color_using_typeof(s: Variant, opts: Dictionary) -> Variant:
	return _core.get_color_using_typeof(s, opts)


static func get_config_color_theme() -> LogColorTheme:
	return _core.config.get_config_color_theme()


static func get_config_color_theme_dict() -> Dictionary:
	return _core.config.get_config_color_theme_dict()


static func get_disable_colors() -> bool:
	return _core.config.get_disable_colors()


static func get_force_termsafe_colors() -> bool:
	return _core.config.get_force_termsafe_colors()


static func color_wrap(s: Variant, opts: Dictionary = {}) -> String:
	return _core.color_wrap(s, opts)


static func should_use_color(opts: Dictionary = {}) -> bool:
	return _core.should_use_color(opts)


##########
# Colors #
##########

## Disable color-wrapping output.
##
## [br][br]
## Useful to declutter the output if the environment does not support colors.
## Note that some environments support only a subset of colors - you may prefer
## [code]set_colors_termsafe()[/code].
static func disable_colors() -> void:
	_core.config.disable_colors()


## Re-enable color-wrapping output.
static func enable_colors() -> void:
	_core.config.enable_colors()


## Use prettier colors - i.e. whatever LogColorTheme is configured.
static func set_colors_pretty() -> void:
	_core.config.set_colors_pretty()


## Use the terminal safe color scheme, which should support colors in most tty-like environments.
static func set_colors_termsafe() -> void:
	_core.config.set_colors_termsafe()


##########
# Config #
##########

static func rebuild_config(opts: Dictionary = {}) -> void:
	LogConfig.rebuild_config(_core.config, opts)


static func setup_settings(opts: Dictionary = {}) -> void:
	LogConfig.setup_settings(opts)


############################
# Floating Point Precision #
############################

static func get_float_precision() -> int:
	return _core.config.get_float_precision()


static func get_float_precision_string() -> String:
	return _core.config.get_float_precision_string()


## Set the expected float precision
static func set_float_precision(float_precision: int) -> void:
	_core.config.set_float_precision(float_precision)


#############
# Log Level #
#############

static func get_log_level() -> int:
	return _core.config.get_log_level()


## Set the minimum level of logs that get printed
static func set_log_level(new_log_level: int) -> void:
	_core.config.set_log_level(new_log_level)


############
# Newlines #
############

## Disable newlines in pretty-print output.
##
## [br][br]
## Useful if you want your log output on a single line, typically for use with
## log aggregation tools.
static func disable_newlines() -> void:
	_core.config.disable_newlines()


## Re-enable newlines in pretty-print output.
static func enable_newlines() -> void:
	_core.config.enable_newlines()


static func get_newline_max_depth() -> int:
	return _core.config.get_newline_max_depth()


static func get_use_newlines() -> bool:
	return _core.config.get_use_newlines()


## Resets the maximum object depth for newlines to the default.
static func reset_newline_max_depth() -> void:
	_core.config.reset_newline_max_depth()


## Set the maximum depth of an object that will get its own newline.
##
## [br][br]
## Useful if you have deeply nested objects where you're primarly interested
## in easily parsing the information near the root of the object.
static func set_newline_max_depth(new_depth: int) -> void:
	_core.config.set_newline_max_depth(new_depth)


##############
# Process ID #
##############

## Show process ID
static func get_show_process_unique_id() -> bool:
	return _core.config.get_show_process_unique_id()


## Don't SHOW_PROCESS_UNIQUE_ID in log line
static func hide_process_unique_id() -> void:
	_core.config.hide_process_unique_id()


## Show SHOW_PROCESS_UNIQUE_ID in log lines
static func show_process_unique_id() -> void:
	_core.config.show_process_unique_id()


##############
# Timestamps #
##############

static func get_show_timestamps() -> bool:
	return _core.config.get_show_timestamps()


static func get_timestamp_format() -> String:
	return _core.config.get_timestamp_format()


static func get_timestamp_type() -> Log.TimestampTypes:
	return _core.config.get_timestamp_type()


## Don't timestamps in log lines
static func hide_timestamps() -> void:
	_core.config.hide_timestamps()


## Show timestamps in log lines
static func show_timestamps() -> void:
	_core.config.show_timestamps()


## Use the given timestamp format
static func use_timestamp_format(timestamp_format: String) -> void:
	_core.config.use_timestamp_format(timestamp_format)


## Use the given timestamp type
static func use_timestamp_type(timestamp_type: Log.TimestampTypes) -> void:
	_core.config.use_timestamp_type(timestamp_type)


###################
# Type Overwrites #
###################

static func clear_type_overwrites() -> void:
	_core.clear_type_overwrites()


## Register a single type overwrite.
##
## [br][br]
## The key should be either obj.get_class() or typeof(var). (Note that using
## typeof(var) may overwrite more broadly than expected).
##
## [br][br]
## The handler is called with the object and an options dict.
## [code]func(obj): return {name=obj.name}[/code]
static func register_type_overwrite(key: String, handler: Callable) -> void:
	_core.register_type_overwrite(key, handler)


## Register a dictionary of type overwrite.
##
## [br][br]
## Expects a Dictionary like [code]{obj.get_class(): func(obj): return
## {key=obj.get_key()}}[/code].
##
## [br][br]
## It depends on [code]obj.get_class()[/code] then [code]typeof(obj)[/code] for
## the key.
## The handler is called with the object as the only argument. (e.g.
## [code]func(obj): return {name=obj.name}[/code]).
static func register_type_overwrites(overwrites: Dictionary) -> void:
	_core.register_type_overwrites(overwrites)


################
# Warn on TODO #
################

## Disable warning on Log.todo().
static func disable_warn_todo() -> void:
	_core.config.disable_warn_todo()


## Enable warning on Log.todo().
static func enable_warn_todo() -> void:
	_core.config.enable_warn_todo()


static func get_warn_todo() -> int:
	return _core.config.get_warn_todo()


#############
# to_pretty #
#############

## Returns the passed object as a bb-colorized string.
##
## [br][br]
## The core of Log.gd's functionality.
##
## [br][br]
## Can be useful to feed directly into a RichTextLabel.
##
static func to_pretty(msg: Variant, opts: Dictionary = {}) -> String:
	return _core.to_pretty(msg, opts)


################
# to_printable #
################

static func to_printable(msgs: Array, opts: Dictionary = {}) -> String:
	return _core.to_printable(msgs, opts)


#############
# timestamp #
#############

static func timestamp() -> String:
	return _core.timestamp()


##########################
# Public Print Functions #
##########################

## Pretty-print the passed arguments in a single line.
static func pr(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.pr(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with a
## newline and indentation.
static func prn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.prn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with two
## newlines and indentation.
static func prnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.prnn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with
## three newlines and indentation.
static func prnnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.prnnn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func log(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.log(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.debug(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func info(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.info(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_warning() with the pretty
## string.
static func warn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.warn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but prepends a "[TODO]" and calls push_warning()
## with the pretty string.
static func todo(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.todo(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty
## string.
static func err(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.err(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty
## string.
static func error(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core.error(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Bespoke log method designed to print data in a tabular fashion.
static func table(msg: Variant, keys: Array = [], max_length: int = 32) -> void:
	if typeof(msg) in [TYPE_INT, TYPE_STRING]:
		print_rich(Log.to_printable([msg], {stack=get_stack()}))
		return

	if keys == [] \
	and typeof(msg) == TYPE_ARRAY \
	and typeof(msg[0]) not in [TYPE_DICTIONARY, TYPE_OBJECT]:
		print_rich(Log.to_printable(msg, {stack=get_stack()}))
		return

	print_rich(Log.to_printable([], {stack=get_stack()}))

	if typeof(msg) != TYPE_ARRAY:
		msg = [msg]

	if keys == [] and typeof(msg[0]) == TYPE_DICTIONARY:
		keys = msg[0].keys()
	elif keys == [] and typeof(msg[0]) == TYPE_OBJECT:
		keys = msg[0].get_property_list() \
			.filter(func(x): return x["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE) \
			.map(func(x): return x["name"])

	var longest_values: Array[int] = []
	for i in range(len(keys)):
		longest_values.append(len(str(keys[i])))

	if typeof(msg[0]) == TYPE_ARRAY:
		for item: Array in msg:
			for i in range(len(item)):
				longest_values[i] = max(longest_values[i], len(str(item[i])))
	elif typeof(msg[0]) == TYPE_DICTIONARY:
		for item: Dictionary in msg:
			var item_values: Array = item.values()
			for i in range(len(item_values)):
				longest_values[i] = max(longest_values[i], len(str(item_values[i])))
	elif typeof(msg[0]) == TYPE_OBJECT:
		for item: Object in msg:
			for i in range(len(keys)):
				var str_value: String = str(item.get(keys[i]))
				longest_values[i] = max(longest_values[i], len(str_value))
	else:
		for i in range(len(msg)):
			longest_values[i] = max(longest_values[i], len(str(msg[i])))

	for i in range(len(longest_values)):
		longest_values[i] = min(longest_values[i], max_length)

	var header: String = "|"
	for i in range(len(keys)):
		header += " " + truncate_string(keys[i], max_length)
		for j in range(max(0, longest_values[i] - len(keys[i]))):
			header += " "
		header += " |"
	header += "\n|"
	for i in range(len(keys)):
		header += "-"
		for j in range(max(0, min(longest_values[i], max_length))):
			header += "-"
		header += "-|"
	print(header)

	var body: String = ""
	if typeof(msg[0]) == TYPE_ARRAY:
		for item: Array in msg:
			for i in range(len(item)):
				var str_value: String = str(item[i])
				body += "| " + truncate_string(str_value, max_length)
				for j in range(max(0, longest_values[i] - len(str_value))):
					body += " "
				body += " "
			body += "|\n"

	elif typeof(msg[0]) == TYPE_DICTIONARY:
		for item: Dictionary in msg:
			var item_values: Array = item.values()
			for i in range(len(item_values)):
				var str_value: String = str(item_values[i])
				body += "| " + truncate_string(str_value, max_length)
				for j in range(max(0, longest_values[i] - len(str_value))):
					body += " "
				body += " "
			body += "|\n"

	elif typeof(msg[0]) == TYPE_OBJECT:
		for item: Object in msg:
			for i in range(len(keys)):
				var str_value: String = str(item.get(keys[i]))
				body += "| " + truncate_string(str_value, max_length)
				for j in range(max(0, longest_values[i] - len(str_value))):
					body += " "
				body += " "
			body += "|\n"

	else:
		for i in range(len(msg)):
			var str_value: String = str(msg[i])
			body += "| " + truncate_string(str_value, max_length)
			for j in range(max(0, longest_values[i] - len(str_value))):
				body += " "
			body += " "
		body += "|\n"

	print(body)


static func truncate_string(input_string: String, target_length: int, suffix: String = "...") -> String:
	var do_suffix: bool = len(input_string) > target_length
	if not len(input_string) > target_length:
		return input_string

	input_string = input_string.substr(0, target_length - suffix.length())
	input_string += suffix
	return input_string


static func blank() -> void:
	_core.blank()


## Helper that will both print() and print_rich() the enriched string
static func _internal_debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	_core._internal_debug(msg, msg2, msg3, msg4, msg5, msg6, msg7)


##############
# Deprecated #
##############

## DEPRECATED
static func merge_theme_overwrites(_opts = {}) -> void:
	pass

## DEPRECATED
static func clear_theme_overwrites() -> void:
	pass
