class_name LogCore
extends Object
## Core logging functionality behind [Log]


var config: LogConfig
var name: String = ""
var type_overwrites: Dictionary = {}


##################
# Static Helpers #
##################

static func assoc(opts: Dictionary, key: String, val: Variant) -> Dictionary:
	var _opts: Dictionary = opts.duplicate(true)
	_opts[key] = val
	return _opts


static func get_process_id() -> int:
	var pid = OS.get_process_id()
	# TODO consider building/using a process detail format? e.g. id/client data?
	return pid


static func is_not_default(v: Variant) -> bool:
	return not v is String or (v is String and v != "ZZZDEF")


static func log_prefix(stack: Array) -> String:
	# NOTE: this filters res://addons/log/* callsites OUT of the stack.
	stack = stack.filter(func(s: Variant) -> bool:
		return s is Dictionary and s.has("source") and not s["source"].contains("res://addons/log/"))

	if len(stack) > 0:
		var call_site: Dictionary = stack[0]
		var call_site_source: String = call_site.get("source", "")
		var basename: String = call_site_source.get_file().get_basename()
		var line_num: String = str(call_site.get("line", 0))
		if call_site_source.match("*/test/*"):
			return "{" + basename + ":" + line_num + "}: "
		elif call_site_source.match("*/addons/*"):
			return "<" + basename + ":" + line_num + ">: "
		else:
			return "[" + basename + ":" + line_num + "]: "
	return ""


## Truncate a string to a maximum length of [param target_length] and a default
## [param suffix] of [code]...[/code] indicating there's more to the string than what was
## printed.  The resulting string will be no longer than [param target_length]
## even when the [param suffix] is appended.
static func _truncate_string(input_string: String, target_length: int, suffix: String = "...") -> String:
	var do_suffix: bool = len(input_string) > target_length
	if not len(input_string) > target_length:
		return input_string

	input_string = input_string.substr(0, target_length - suffix.length())
	input_string += suffix
	return input_string


#############
# Built-ins #
#############

func _init(p_name: String, p_config: LogConfig = LogConfig.new()) -> void:
	name = p_name
	config = p_config


##########
# Colors #
##########

func color_wrap(s: Variant, opts: Dictionary = {}) -> String:
	# TODO refactor to use the color theme directly
	var color_theme: LogColorTheme = config.get_config_color_theme()

	if not should_use_color(opts):
		return str(s)

	var color: Variant = opts.get("color", "")
	if color == null or (color is String and color == ""):
		color = get_color_using_typeof(s, opts)

	if color is String and color == "" or color == null:
		print("Log.gd could not determine color for object: %s type: (%s)" % [str(s), typeof(s)])

	if color is Array:
		# support rainbow delimiters
		if opts.get("typeof", "") in ["dict_key"]:
			# subtract 1 for dict_keys
			# we the keys are 'down' a nesting level, but we want the curly + dict keys to match
			color = color[(opts.get("newline_depth", 0) - 1) % len(color)]
		else:
			color = color[opts.get("newline_depth", 0) % len(color)]

	if color is Color:
		# get the colors back to something bb_code can handle
		color = color.to_html(false)

	if color_theme and color_theme.has_bg():
		var bg_color: String = color_theme.get_bg_color(opts.get("newline_depth", 0)).to_html(false)
		return "[bgcolor=%s][color=%s]%s[/color][/bgcolor]" % [bg_color, color, s]
	return "[color=%s]%s[/color]" % [color, s]


func get_color_using_typeof(s: Variant, opts: Dictionary) -> Variant:
	var colors: Dictionary = config.get_config_color_theme_dict()
	var color: Variant
	var s_type: Variant = opts.get("typeof", typeof(s))
	if s_type is String:
		# type overwrites
		color = colors.get(s_type)
	elif s_type is int and s_type == TYPE_STRING:
		# specific strings/punctuation
		var s_trimmed: String = str(s).strip_edges()
		if s_trimmed in colors:
			color = colors.get(s_trimmed)
		else:
			# fallback string color
			color = colors.get(s_type)
	else:
		# all other types
		color = colors.get(s_type)
	return color


func should_use_color(opts: Dictionary = {}) -> bool:
	if OS.has_feature("ios") or OS.has_feature("web"):
		# ios and web (and likely others) don't handle colors well
		return false
	if config.get_disable_colors():
		return false
	# supports per-print color skipping
	if opts.get("disable_colors", false):
		return false
	return true


#############
# timestamp #
#############

func timestamp() -> String:
	match config.get_timestamp_type():
		Log.TimestampTypes.UNIX:
			return "%d" % Time.get_unix_time_from_system()
		Log.TimestampTypes.TICKS_MSEC:
			return "%d" % Time.get_ticks_msec()
		Log.TimestampTypes.TICKS_USEC:
			return "%d" % Time.get_ticks_usec()
		Log.TimestampTypes.HUMAN_12HR:
			var time: Dictionary = Time.get_datetime_dict_from_system()
			var hour: int = time.hour % 12
			if hour == 0:
				hour = 12
			var meridiem: String = "AM" if time.hour < 12 else "PM"
			return config.get_timestamp_format().format({
					"year": time.year,
					"month": "%02d" % time.month,
					"day": "%02d" % time.day,
					"hour": hour,
					"minute": "%02d" % time.minute,
					"second": "%02d" % time.second,
					"meridiem": meridiem,
					"dst": time.dst
				})
		Log.TimestampTypes.HUMAN_24HR:
			var time: Dictionary = Time.get_datetime_dict_from_system()
			return config.get_timestamp_format().format({
					"year": time.year,
					"month": "%02d" % time.month,
					"day": "%02d" % time.day,
					"hour": "%02d" % time.hour,
					"minute": "%02d" % time.minute,
					"second": "%02d" % time.second,
					"dst": time.dst
				})
	return "%d" % Time.get_unix_time_from_system()


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
func to_pretty(msg: Variant, opts: Dictionary = {}) -> String:
	var newlines: bool = opts.get("newlines", config.get_use_newlines())
	var newline_depth: int = opts.get("newline_depth", 0)
	var newline_max_depth: int = opts.get("newline_max_depth", config.get_newline_max_depth())
	var indent_level: int = opts.get("indent_level", 0)

	if not newlines:
		newline_max_depth = 0
	elif newline_max_depth == 0:
		newlines = false

	# If newline_max_depth is negative, don't limit the depth
	if newline_max_depth > 0 and newline_depth >= newline_max_depth:
		newlines = false

	if not "newline_depth" in opts:
		opts["newline_depth"] = newline_depth

	if not "indent_level" in opts:
		opts["indent_level"] = indent_level

	if not is_instance_valid(msg) and typeof(msg) == TYPE_OBJECT:
		return str("invalid instance: ", msg)

	if msg == null:
		return color_wrap(msg, opts)

	if msg is Object and (msg as Object).get_class() in type_overwrites:
		var fn: Callable = type_overwrites.get((msg as Object).get_class())
		return to_pretty(fn.call(msg), opts)
	elif typeof(msg) in type_overwrites:
		var fn: Callable = type_overwrites.get(typeof(msg))
		return to_pretty(fn.call(msg), opts)

	# objects
	if msg is Object and (msg as Object).has_method("to_pretty"):
		# using a cast and `call.("blah")` here it's "type safe"
		return to_pretty((msg as Object).call("to_pretty"), opts)
	if msg is Object and (msg as Object).has_method("data"):
		return to_pretty((msg as Object).call("data"), opts)
	# DEPRECATED
	if msg is Object and (msg as Object).has_method("to_printable"):
		return to_pretty((msg as Object).call("to_printable"), opts)

	# arrays
	if msg is Array or msg is PackedStringArray:
		var msg_array: Array = msg
		if len(msg) > config.get_max_array_size():
			Log.pr("[DEBUG]: truncating large array. total:", len(msg))
			msg_array = msg_array.slice(0, config.get_max_array_size() - 1)
			if newlines:
				msg_array.append("...")

		# shouldn't we be incrementing index_level here?
		var tmp: String = color_wrap("[ ", opts)
		opts["newline_depth"] += 1
		var last: int = len(msg) - 1
		for i: int in range(len(msg)):
			if newlines and last > 1:
				tmp += color_wrap("\n\t", opts)
			tmp += to_pretty(msg[i],
				# duplicate here to prevent indenting-per-msg
				# e.g. when printing an array of dictionaries
				opts.duplicate(true))
			if i != last:
				tmp += color_wrap(", ", opts)
		opts["newline_depth"] -= 1
		tmp += color_wrap(" ]", opts)
		return tmp

	# dictionary
	elif msg is Dictionary:
		var tmp: String = color_wrap("{ ", opts)
		opts["newline_depth"] += 1
		var ct: int = len(msg)
		var last: Variant
		if len(msg) > 0:
			last = (msg as Dictionary).keys()[-1]
		var indent_updated = false
		for k: Variant in (msg as Dictionary).keys():
			var val: Variant
			if k in config.get_dictionary_skip_keys():
				val = "..."
			else:
				if not indent_updated:
					indent_updated = true
					opts["indent_level"] += 1
				val = to_pretty(msg[k], opts)
			if newlines and ct > 1:
				tmp += color_wrap("\n\t", opts) \
					+ color_wrap(range(indent_level)\
					.map(func(_i: int) -> String: return "\t")\
					.reduce(func(a: String, b: Variant) -> String: return str(a, b), ""), opts)
			var key: String = color_wrap('"%s"' % k, assoc(opts, "typeof", "dict_key"))
			tmp += "%s%s%s" % [key, color_wrap(": ", opts), val]
			if last and str(k) != str(last):
				tmp += color_wrap(", ", opts)
		opts["newline_depth"] -= 1
		tmp += color_wrap(" }", opts)
		opts["indent_level"] -= 1 # ugh! updating the dict in-place
		return tmp

	elif msg is float:
		return color_wrap(config.get_float_precision_string() % msg, opts)

	# strings
	elif msg is String:
		if msg == "":
			return '""'
		if "[color=" in msg and "[/color]" in msg:
			# passes through strings that might already be colorized?
			# can't remember this use-case
			# perhaps should use a regex and unit tests for something more robust
			return msg
		return Log.color_wrap(msg, opts)
	elif msg is StringName:
		return str(Log.color_wrap("&", opts), '"%s"' % msg)
	elif msg is NodePath:
		return str(Log.color_wrap("^", opts), '"%s"' % msg)

	elif msg is Color:
		# probably too opinionated, but seeing 4 floats for color is noisey
		return Log.color_wrap(msg.to_html(false), assoc(opts, "typeof", TYPE_COLOR))

	# vectors
	elif msg is Vector2:
		return '%s%s%s%s%s' % [
			color_wrap("(", opts),
			color_wrap(config.get_float_precision_string() % msg.x, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(config.get_float_precision_string() % msg.y, assoc(opts, "typeof", "vector_value")),
			color_wrap(")", opts),
		]
	elif msg is Vector2i:
		return '%s%s%s%s%s' % [
			color_wrap("(", opts),
			color_wrap(msg.x, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(msg.y, assoc(opts, "typeof", "vector_value")),
			color_wrap(")", opts),
		]

	elif msg is Vector3:
		return '%s%s%s%s%s%s%s' % [
			color_wrap("(", opts),
			color_wrap(config.get_float_precision_string() % msg.x, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(config.get_float_precision_string() % msg.y, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(config.get_float_precision_string() % msg.z, assoc(opts, "typeof", "vector_value")),
			color_wrap(")", opts),
		]
	elif msg is Vector3i:
		return '%s%s%s%s%s%s%s' % [
			color_wrap("(", opts),
			color_wrap(msg.x, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(msg.y, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(msg.z, assoc(opts, "typeof", "vector_value")),
			color_wrap(")", opts),
		]

	elif msg is Vector4:
		return '%s%s%s%s%s%s%s%s%s' % [
			color_wrap("(", opts),
			color_wrap(config.get_float_precision_string() % msg.x, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(config.get_float_precision_string() % msg.y, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(config.get_float_precision_string() % msg.z, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(config.get_float_precision_string() % msg.w, assoc(opts, "typeof", "vector_value")),
			color_wrap(")", opts),
		]
	elif msg is Vector4i:
		return '%s%s%s%s%s%s%s%s%s' % [
			color_wrap("(", opts),
			color_wrap(msg.x, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(msg.y, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(msg.z, assoc(opts, "typeof", "vector_value")),
			color_wrap(", ", opts),
			color_wrap(msg.w, assoc(opts, "typeof", "vector_value")),
			color_wrap(")", opts),
		]

	# rects
	elif msg is Rect2:
		return '%s%s%s%s' % [
			color_wrap("(", opts),
			color_wrap("P: %s, " % to_pretty(msg.position, opts), opts),
			color_wrap("X: %s" % to_pretty(msg.size, opts), opts),
			color_wrap(")", opts),
		]
	elif msg is Rect2i:
		return '%s%s%s%s' % [
			color_wrap("(", opts),
			color_wrap("P: %s, " % to_pretty(msg.position, opts), opts),
			color_wrap("X: %s" % to_pretty(msg.size, opts), opts),
			color_wrap(")", opts),
		]

	# transforms
	elif msg is Transform2D:
		return '%s%s%s%s%s' % [
			color_wrap("[", opts),
			color_wrap("X: %s, " % to_pretty(msg.x, opts), opts),
			color_wrap("Y: %s, " % to_pretty(msg.y, opts), opts),
			color_wrap("O: %s" % to_pretty(msg.origin, opts), opts),
			color_wrap("]", opts),
		]
	elif msg is Transform3D:
		return '%s%s%s%s%s%s' % [
			color_wrap("[", opts),
			color_wrap("X: %s, " % to_pretty(msg.basis.x, opts), opts),
			color_wrap("Y: %s, " % to_pretty(msg.basis.y, opts), opts),
			color_wrap("Z: %s, " % to_pretty(msg.basis.z, opts), opts),
			color_wrap("O: %s" % to_pretty(msg.origin, opts), opts),
			color_wrap("]", opts),
		]

	# packed scene
	elif msg is PackedScene:
		var msg_ps: PackedScene = msg
		if msg_ps.resource_path != "":
			return str(Log.color_wrap("PackedScene:", opts), '%s' % msg_ps.resource_path.get_file())
		elif msg_ps.get_script() != null and msg_ps.get_script().resource_path != "":
			var path: String = msg_ps.get_script().resource_path
			return Log.color_wrap(path.get_file(), assoc(opts, "typeof", "class_name"))
		else:
			return Log.color_wrap(msg_ps, opts)

	# resource
	elif msg is Resource:
		var msg_res: Resource = msg
		if msg_res.get_script() != null and msg_res.get_script().resource_path != "":
			var path: String = msg_res.get_script().resource_path
			return Log.color_wrap(path.get_file(), assoc(opts, "typeof", "class_name"))
		elif msg_res.resource_path != "":
			var path: String = msg_res.resource_path
			return str(Log.color_wrap("Resource:", opts), '%s' % path.get_file())
		else:
			return Log.color_wrap(msg_res, opts)

	# refcounted
	elif msg is RefCounted:
		var msg_ref: RefCounted = msg
		if msg_ref.get_script() != null and msg_ref.get_script().resource_path != "":
			var path: String = msg_ref.get_script().resource_path
			return Log.color_wrap(path.get_file(), assoc(opts, "typeof", "class_name"))
		else:
			return Log.color_wrap(msg_ref.get_class(), assoc(opts, "typeof", "class_name"))

	# fallback to primitive-type lookup
	else:
		return Log.color_wrap(msg, opts)


################
# to_printable #
################

func to_printable(msgs: Array, opts: Dictionary = {}) -> String:
	if not config.is_config_setup:
		LogConfig.rebuild_config(config)

	if not msgs is Array:
		msgs = [msgs]
	var stack: Array = opts.get("stack", [])
	var pretty: bool = opts.get("pretty", true)
	var m: String = ""

	# Set ProcessID
	if config.get_show_process_unique_id():
		# TODO colorize
		m += "[%s]" % get_process_id()

	if name and name != Log.LOGGER_NAME:
		m += "[%s]" % name

	if config.get_show_timestamps():
		m += "[%s]" % timestamp()

	if len(stack) > 0:
		var prefix: String = log_prefix(stack)
		var prefix_type: String
		if prefix != null and prefix[0] == "[":
			prefix_type = "SRC"
		elif prefix != null and prefix[0] == "{":
			prefix_type = "TEST"
		elif prefix != null and prefix[0] == "<":
			prefix_type = "ADDONS"
		if pretty:
			m += color_wrap(prefix, assoc(opts, "typeof", prefix_type))
		else:
			m += prefix
	for msg: Variant in msgs:
		# add a space between msgs
		if pretty:
			m += "%s " % to_pretty(msg, opts)
		else:
			m += "%s " % str(msg)
	return m.trim_suffix(" ")


###################
# Type Overwrites #
###################

func clear_type_overwrites() -> void:
	type_overwrites = {}


## Register a single type overwrite.
##
## [br][br]
## The key should be either obj.get_class() or typeof(var). (Note that using typeof(var) may overwrite more broadly than expected).
##
## [br][br]
## The handler is called with the object and an options dict.
## [code]func(obj): return {name=obj.name}[/code]
func register_type_overwrite(key: String, handler: Callable) -> void:
	# TODO warning on key exists? support multiple handlers for same type?
	# validate the key/handler somehow?
	type_overwrites[key] = handler


## Register a dictionary of type overwrite.
##
## [br][br]
## Expects a Dictionary like [code]{obj.get_class(): func(obj): return {key=obj.get_key()}}[/code].
##
## [br][br]
## It depends on [code]obj.get_class()[/code] then [code]typeof(obj)[/code] for the key.
## The handler is called with the object as the only argument. (e.g. [code]func(obj): return {name=obj.name}[/code]).
func register_type_overwrites(overwrites: Dictionary) -> void:
	type_overwrites.merge(overwrites, true)


##########################
# Public Print Functions #
##########################

## Pretty-print the passed arguments in a single line.
func pr(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var m: String = to_printable(msgs, {stack=get_stack()})
	print_rich(m)


## Pretty-print the passed arguments, expanding dictionaries and arrays with a newline and indentation.
func prn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var m: String = to_printable(msgs, {stack=get_stack(), newlines=true, newline_max_depth=1})
	print_rich(m)


## Pretty-print the passed arguments, expanding dictionaries and arrays with two newlines and indentation.
func prnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var m: String = to_printable(msgs, {stack=get_stack(), newlines=true, newline_max_depth=2})
	print_rich(m)


## Pretty-print the passed arguments, expanding dictionaries and arrays with three newlines and indentation.
func prnnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var m: String = to_printable(msgs, {stack=get_stack(), newlines=true, newline_max_depth=3})
	print_rich(m)


## Pretty-print the passed arguments in a single line.
func log(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var m: String = to_printable(msgs, {stack=get_stack()})
	print_rich(m)


## Pretty-print the passed arguments in a single line.
func debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if config.get_log_level() > Log.Levels.DEBUG:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	msgs.push_front("[DEBUG]")
	var m: String = to_printable(msgs, {stack=get_stack()})
	print_rich(m)


## Pretty-print the passed arguments in a single line.
func info(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if config.get_log_level() > Log.Levels.INFO:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	msgs.push_front("[INFO]")
	var m: String = to_printable(msgs, {stack=get_stack()})
	print_rich(m)


## Like [code]Log.pr()[/code], but also calls push_warning() with the pretty string.
func warn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if config.get_log_level() > Log.Levels.WARN:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(to_printable(rich_msgs, {stack=get_stack()}))
	# skip the 'color' features in warnings to keep them readable in the debugger
	var m: String = to_printable(msgs, {stack=get_stack(), disable_colors=true})
	push_warning(m)


## Like [code]Log.pr()[/code], but prepends a "[TODO]" and calls push_warning() with the pretty string.
func todo(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if config.get_warn_todo() and config.get_log_level() > Log.Levels.WARN:
		return
	elif not config.get_warn_todo() and config.get_log_level() > Log.Levels.INFO:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	msgs.push_front("[TODO]")
	var rich_msgs: Array = msgs.duplicate()
	if config.get_warn_todo():
		rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(to_printable(rich_msgs, {stack=get_stack()}))
	if config.get_warn_todo():
		var m: String = to_printable(msgs, {stack=get_stack(), disable_colors=true})
		push_warning(m)


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty string.
func err(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(to_printable(rich_msgs, {stack=get_stack()}))
	# skip the 'color' features in errors to keep them readable in the debugger
	var m: String = to_printable(msgs, {stack=get_stack(), disable_colors=true})
	push_error(m)


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty string.
func error(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(to_printable(rich_msgs, {stack=get_stack()}))
	# skip the 'color' features in errors to keep them readable in the debugger
	var m: String = to_printable(msgs, {stack=get_stack(), disable_colors=true})
	push_error(m)


## Bespoke method designed to print data in a tabular fashion.[br]
## [br]
## Creates multi-line output where the first line is the standard Log.gd
## preface, the second line is the table header, the third line is the header
## separator, then each subsequent line is a row of table data.
func table(
	msg: Variant,
	config: LogTableConfig = LogTableConfig.new()
) -> void:
	if typeof(msg) in [TYPE_INT, TYPE_STRING]:
		print_rich(to_printable([msg], {stack=get_stack()}))
		return

	if config.columns == [] \
	and typeof(msg) == TYPE_ARRAY \
	and typeof(msg[0]) not in [TYPE_DICTIONARY, TYPE_OBJECT]:
		print_rich(to_printable(msg, {stack=get_stack()}))
		return

	print_rich(to_printable([], {stack=get_stack()}))

	if typeof(msg) != TYPE_ARRAY:
		msg = [msg]

	if config.columns == [] and typeof(msg[0]) == TYPE_DICTIONARY:
		config.columns = msg[0].keys()
	elif config.columns == [] and typeof(msg[0]) == TYPE_OBJECT:
		config.columns = msg[0].get_property_list() \
			.filter(func(x): return x["usage"] in [
				# TODO-table: Clean up bitmask usage
				PROPERTY_USAGE_SCRIPT_VARIABLE,
				PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_CLASS_IS_ENUM
			]) \
			.map(func(x): return x["name"])

	var longest_values: Array[int] = []
	for i in range(len(config.columns)):
		longest_values.append(len(str(config.columns[i])))

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
			for i in range(len(config.columns)):
				var str_value: String = str(item.get(config.columns[i]))
				longest_values[i] = max(longest_values[i], len(str_value))
	else:
		for i in range(len(msg)):
			longest_values[i] = max(longest_values[i], len(str(msg[i])))

	for i in range(len(longest_values)):
		longest_values[i] = min(longest_values[i], config.max_length)

	var header: String = LogTable.header(config, longest_values)
	print_rich(header)

	var body: String = LogTable.body(config, longest_values, msg)
	print_rich(body)


func blank() -> void:
	print()


####################
# Internal methods #
####################

## Helper that will both print() and print_rich() the enriched string
func _internal_debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_default)
	var m: String = to_printable(msgs, {stack=get_stack()})
	print("_internal_debug: ", m)
	print_rich(m)
