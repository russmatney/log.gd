class_name LogCore
extends Object
## Core logging functionality behind [Log]


var config: LogConfig
var name: String = ""
var type_overwrites: Dictionary = {}

################
# Opts Classes #
################

class PrettyOpts:
	extends Object

	var use_newlines: Variant = null
	var newline_max_depth: Variant = null
	var disable_colors: Variant = null
	var show_prefix: bool = true
	var skip_callsite: bool = false

	func _init(opts: Dictionary) -> void:
		use_newlines = opts.get("newlines")
		newline_max_depth = opts.get("newline_max_depth")
		disable_colors = opts.get("disable_colors")
		show_prefix = opts.get("show_prefix", true)
		skip_callsite = opts.get("skip_callsite", false)

	func apply_config(config: LogConfig) -> PrettyOpts:
		if newline_max_depth == null:
			newline_max_depth = config.get_newline_max_depth()
		if use_newlines == null:
			use_newlines = config.get_use_newlines()
		if disable_colors == null:
			disable_colors = config.get_disable_colors()
		return self

	func no_color() -> PrettyOpts:
		disable_colors = true
		return self

	func no_prefix() -> PrettyOpts:
		show_prefix = false
		return self

	static func with_depth(depth: int) -> PrettyOpts:
		return PrettyOpts.new({newlines=true, newline_max_depth=depth})

	static func simple() -> PrettyOpts:
		return PrettyOpts.new({newlines=false, disable_colors=true, skip_callsite=true})


class ColorOpts:
	extends Object

	var color: Variant = null
	var depth: int = 0
	var disable_color: bool = false

	func _init(_depth: int = 0, _color: Variant = null, _disable: bool = false) -> void:
		color = _color
		depth = _depth
		disable_color = _disable

	func no_color() -> ColorOpts:
		disable_color = true
		return self

	static func from_dict(opts: Dictionary) -> ColorOpts:
		var color: Variant = opts.get("color", null)
		var depth: int = opts.get("depth", 0)
		var disable: bool = opts.get("disable_colors")
		return ColorOpts.new(depth, color, disable)

	static func from_color_opts(color_opts: ColorOpts) -> ColorOpts:
		return ColorOpts.new(color_opts.depth, color_opts.color, color_opts.disable_color)


class Ctx:
	var use_newlines: Variant = null
	var newline_depth: int = 0
	var indent_level: int = 0

	static func from(ctx: Ctx) -> Ctx:
		var new_ctx: Ctx = Ctx.new()
		new_ctx.use_newlines = ctx.use_newlines
		new_ctx.newline_depth = ctx.newline_depth
		new_ctx.indent_level = ctx.indent_level
		return new_ctx


#############
# Built-ins #
#############

func _init(p_name: String, p_config: LogConfig = LogConfig.new()) -> void:
	name = p_name
	config = p_config


##########
# Colors #
##########


## Wraps the passed var in bb-code color tags. Uses typeof() to determine the color. [br]
## [br]
## [opts] is a dictionary supporting various overrides.
func color_wrap(s: Variant, opts: Dictionary = {}) -> String:
	return _color_wrap(s, ColorOpts.from_dict(opts), opts.get("type"))


func _color_wrap(s: Variant, color_opts: ColorOpts, type: Variant = null) -> String:
	# TODO refactor to use the color theme directly
	var color_theme: LogColorTheme = config.get_config_color_theme()

	if not _should_use_color(color_opts):
		return str(s)

	var color: Variant = color_opts.color
	if color == null or (color is String and color == ""):
		var string_type = type if type else typeof(s)
		color = _get_color_using_typeof(s, string_type)

	if color is String and color == "" or color == null:
		print("Log.gd could not determine color for object: %s type: (%s)" % [str(s), typeof(s)])

	# rainbow delimiters - pass an array of colors, use 'depth' and mod to select a color
	if color is Array:
		if type in ["dict_key"]:
			# select the previous color for dict_keys so curly + dictionary keys to match
			color = color[(color_opts.depth - 1) % len(color)]
		else:
			color = color[color_opts.depth % len(color)]

	if color is Color:
		# convert Color type to something bb_code can handle
		color = color.to_html(false)

	if color_theme and color_theme.has_bg():
		var bg_color: String = color_theme.get_bg_color(color_opts.depth).to_html(false)
		return "[bgcolor=%s][color=%s]%s[/color][/bgcolor]" % [bg_color, color, s]
	return "[color=%s]%s[/color]" % [color, s]


func _get_color_using_typeof(s: Variant, s_type: Variant) -> Variant:
	var colors: Dictionary = config.get_config_color_theme_dict()
	var color: Variant
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


func _should_use_color(color_opts: ColorOpts) -> bool:
	if OS.has_feature("ios") or OS.has_feature("web"):
		# ios and web (and likely others) don't handle colors well
		return false
	if config.get_disable_colors():
		return false
	# supports per-print color skipping
	if color_opts.disable_color:
		return false
	if color_opts.color == false:
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
	return _to_pretty(msg, PrettyOpts.new(opts).apply_config(config))


# This function is called recursively until we have a string representing the passed 'msg'.
func _to_pretty(msg: Variant, pretty_opts: PrettyOpts, color_opts: ColorOpts = null, ctx: Ctx = null) -> String:
	if not is_instance_valid(msg) and typeof(msg) == TYPE_OBJECT:
		return str("invalid instance: ", msg)

	# setup ctx for the top of the recursion
	if ctx == null:
		ctx = Ctx.new()
		ctx.use_newlines = pretty_opts.use_newlines

		if not ctx.use_newlines:
			pretty_opts.newline_max_depth = 0
		elif pretty_opts.newline_max_depth == 0:
			ctx.use_newlines = false

	# build ColorOpts
	if color_opts == null:
		color_opts = ColorOpts.new()
		if pretty_opts.disable_colors:
			color_opts.no_color()

	# enforce max depth (disable newlines if we've reached the max)
	if pretty_opts.newline_max_depth > 0 and ctx.newline_depth >= pretty_opts.newline_max_depth:
		ctx.use_newlines = false

	if msg == null:
		return _color_wrap(msg, color_opts)

	if msg is Object and (msg as Object).get_class() in type_overwrites:
		var fn: Callable = type_overwrites.get((msg as Object).get_class())
		return _to_pretty(fn.call(msg), pretty_opts, color_opts, ctx)
	elif typeof(msg) in type_overwrites:
		var fn: Callable = type_overwrites.get(typeof(msg))
		return _to_pretty(fn.call(msg), pretty_opts, color_opts, ctx)

	# objects
	if msg is Object and (msg as Object).has_method("to_pretty"):
		# using a cast and `call.("blah")` here it's "type safe"
		return _to_pretty((msg as Object).call("to_pretty"), pretty_opts, color_opts, ctx)
	if msg is Object and (msg as Object).has_method("data"):
		return _to_pretty((msg as Object).call("data"), pretty_opts, color_opts, ctx)

	# arrays
	if msg is Array or msg is PackedStringArray:
		var msg_array: Array = msg
		if len(msg) > config.get_max_array_size():
			Log.pr("[DEBUG]: truncating large array. total:", len(msg))
			msg_array = msg_array.slice(0, config.get_max_array_size() - 1)
			if ctx.use_newlines:
				msg_array.append("...")

		# shouldn't we be incrementing index_level here?
		var tmp: String = _color_wrap("[ ", color_opts)
		ctx.newline_depth += 1
		color_opts.depth += 1
		var last: int = len(msg) - 1
		for i: int in range(len(msg)):
			if ctx.use_newlines and last > 1:
				tmp += _color_wrap("\n", color_opts)
				var indents = range(ctx.indent_level)\
					.map(func(_i: int) -> String: return "\t")\
					.reduce(func(a: String, b: Variant) -> String: return str(a, b), "")
				tmp += _color_wrap(indents, color_opts)

			# we are in an array, recursing on nested values
			# do we need to dupe the context here? (might be missing nested array test-case?)
			tmp += _to_pretty(msg[i], pretty_opts, color_opts, ctx)
			if i != last:
				tmp += _color_wrap(", ", color_opts)
		ctx.newline_depth -= 1
		color_opts.depth -= 1
		tmp += _color_wrap(" ]", color_opts)
		return tmp

	# dictionary
	elif msg is Dictionary:
		var tmp: String = _color_wrap("{ ", color_opts)
		ctx.newline_depth += 1
		color_opts.depth += 1
		var ct: int = len(msg)
		var last: Variant
		if len(msg) > 0:
			last = (msg as Dictionary).keys()[-1]
		var indent_updated: bool = false
		var indent_level: int = ctx.indent_level
		for k: Variant in (msg as Dictionary).keys():
			var val: Variant
			if k in config.get_dictionary_skip_keys():
				val = "..."
			else:
				if not indent_updated:
					indent_updated = true
					ctx.indent_level += 1
				# recursing within a dictionary
				val = _to_pretty(msg[k], pretty_opts, color_opts,
					# dupe the context so nested vals start from the same indent_level
					Ctx.from(ctx))
			if ctx.use_newlines and ct > 1:
				tmp += _color_wrap("\n\t", color_opts)
				var indents = range(indent_level)\
					.map(func(_i: int) -> String: return "\t")\
					.reduce(func(a: String, b: Variant) -> String: return str(a, b), "")
				tmp += _color_wrap(indents, color_opts)
			var key: String = _color_wrap('"%s"' % k, color_opts, "dict_key")
			tmp += "%s%s%s" % [key, _color_wrap(": ", color_opts), val]
			if last and str(k) != str(last):
				tmp += _color_wrap(", ", color_opts)
		ctx.newline_depth -= 1
		color_opts.depth -= 1
		tmp += _color_wrap(" }", color_opts)
		ctx.indent_level -= 1
		return tmp

	elif msg is float:
		return _color_wrap(config.get_float_precision_string() % msg, color_opts)

	# strings
	elif msg is String:
		if msg == "":
			return '""'
		if "[color=" in msg and "[/color]" in msg:
			# passes through strings that might already be colorized?
			# can't remember this use-case
			# perhaps should use a regex and unit tests for something more robust
			return msg
		return _color_wrap(msg, color_opts)
	elif msg is StringName:
		return str(_color_wrap("&", color_opts), '"%s"' % msg)
	elif msg is NodePath:
		return str(_color_wrap("^", color_opts), '"%s"' % msg)

	elif msg is Color:
		# probably too opinionated, but seeing 4 floats for color is noisey
		return _color_wrap(msg.to_html(false), color_opts, TYPE_COLOR)

	# vectors
	elif msg is Vector2:
		return '%s%s%s%s%s' % [
			_color_wrap("(", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.x, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.y, color_opts, "vector_value"),
			_color_wrap(")", color_opts),
		]
	elif msg is Vector2i:
		return '%s%s%s%s%s' % [
			_color_wrap("(", color_opts),
			_color_wrap(msg.x, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(msg.y, color_opts, "vector_value"),
			_color_wrap(")", color_opts),
		]

	elif msg is Vector3:
		return '%s%s%s%s%s%s%s' % [
			_color_wrap("(", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.x, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.y, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.z, color_opts, "vector_value"),
			_color_wrap(")", color_opts),
		]
	elif msg is Vector3i:
		return '%s%s%s%s%s%s%s' % [
			_color_wrap("(", color_opts),
			_color_wrap(msg.x, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(msg.y, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(msg.z, color_opts, "vector_value"),
			_color_wrap(")", color_opts),
		]

	elif msg is Vector4:
		return '%s%s%s%s%s%s%s%s%s' % [
			_color_wrap("(", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.x, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.y, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.z, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(config.get_float_precision_string() % msg.w, color_opts, "vector_value"),
			_color_wrap(")", color_opts),
		]
	elif msg is Vector4i:
		return '%s%s%s%s%s%s%s%s%s' % [
			_color_wrap("(", color_opts),
			_color_wrap(msg.x, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(msg.y, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(msg.z, color_opts, "vector_value"),
			_color_wrap(", ", color_opts),
			_color_wrap(msg.w, color_opts, "vector_value"),
			_color_wrap(")", color_opts),
		]

	# rects
	elif msg is Rect2:
		return '%s%s%s%s' % [
			_color_wrap("(", color_opts),
			_color_wrap("P: %s, " % _to_pretty(msg.position, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("X: %s" % _to_pretty(msg.size, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap(")", color_opts),
		]
	elif msg is Rect2i:
		return '%s%s%s%s' % [
			_color_wrap("(", color_opts),
			_color_wrap("P: %s, " % _to_pretty(msg.position, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("X: %s" % _to_pretty(msg.size, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap(")", color_opts),
		]

	# transforms
	elif msg is Transform2D:
		return '%s%s%s%s%s' % [
			_color_wrap("[", color_opts),
			_color_wrap("X: %s, " % _to_pretty(msg.x, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("Y: %s, " % _to_pretty(msg.y, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("O: %s" % _to_pretty(msg.origin, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("]", color_opts),
		]
	elif msg is Transform3D:
		return '%s%s%s%s%s%s' % [
			_color_wrap("[", color_opts),
			_color_wrap("X: %s, " % _to_pretty(msg.basis.x, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("Y: %s, " % _to_pretty(msg.basis.y, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("Z: %s, " % _to_pretty(msg.basis.z, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("O: %s" % _to_pretty(msg.origin, pretty_opts, color_opts, ctx), color_opts),
			_color_wrap("]", color_opts),
		]

	# packed scene
	elif msg is PackedScene:
		var msg_ps: PackedScene = msg
		if msg_ps.resource_path != "":
			return str(_color_wrap("PackedScene:", color_opts), '%s' % msg_ps.resource_path.get_file())
		elif msg_ps.get_script() != null and msg_ps.get_script().resource_path != "":
			var path: String = msg_ps.get_script().resource_path
			return _color_wrap(path.get_file(), color_opts, "class_name")
		else:
			return _color_wrap(msg_ps, color_opts)

	# resource
	elif msg is Resource:
		var msg_res: Resource = msg
		if msg_res.get_script() != null and msg_res.get_script().resource_path != "":
			var path: String = msg_res.get_script().resource_path
			return _color_wrap(path.get_file(), color_opts, "class_name")
		elif msg_res.resource_path != "":
			var path: String = msg_res.resource_path
			return str(_color_wrap("Resource:", color_opts), '%s' % path.get_file())
		else:
			return _color_wrap(msg_res, color_opts)

	# refcounted
	elif msg is RefCounted:
		var msg_ref: RefCounted = msg
		if msg_ref.get_script() != null and msg_ref.get_script().resource_path != "":
			var path: String = msg_ref.get_script().resource_path
			return _color_wrap(path.get_file(), color_opts, "class_name")
		else:
			return _color_wrap(msg_ref.get_class(), color_opts, "class_name")

	# fallback to primitive-type lookup
	else:
		return _color_wrap(msg, color_opts)


##########
# Prefix #
##########

# callsite
func prefix_callsite(pretty_opts: PrettyOpts, color_opts: ColorOpts) -> String:
	var m: String = ""

	if pretty_opts.skip_callsite:
		return m

	var stack: Array = get_stack()
	stack = stack.filter(func(s: Variant) -> bool:
		# filters res://addons/log/* callsites OUT of the stack
		# assumes the first non-log callsite is the one we want
		return s is Dictionary and s.has("source") and not s["source"].contains("res://addons/log/"))
	if len(stack) == 0:
		return m

	var call_site: Dictionary = stack[0]
	var call_site_source: String = call_site.get("source", "")
	var basename: String = call_site_source.get_file().get_basename()
	var line_num: String = str(call_site.get("line", 0))
	var prefix_type := ""
	if call_site_source.match("*/test/*"):
		m = "{" + basename + ":" + line_num + "}: "
		prefix_type = "TEST"
	elif call_site_source.match("*/addons/*"):
		m = "<" + basename + ":" + line_num + ">: "
		prefix_type = "ADDONS"
	else:
		m = "[" + basename + ":" + line_num + "]: "
		prefix_type = "SRC"

	if not pretty_opts.disable_colors:
		m = _color_wrap(m, color_opts, prefix_type)
	return m

# proc id
static func get_process_id() -> int:
	return OS.get_process_id()


func prefix_process_id() -> String:
	if not config.get_show_process_unique_id():
		return ""
	return "[%s]" % get_process_id()


# timestamp
func prefix_timestamp() -> String:
	if not config.get_show_timestamps():
		return ""
	return "[%s]" % timestamp()


# custom logger name
func prefix_logger_name():
	if not (name and name != Log.LOGGER_NAME):
		return ""
	return "[%s]" % name


# build_prefix
func build_prefix(pretty_opts: PrettyOpts, color_opts: ColorOpts = null) -> String:
	if color_opts == null:
		color_opts = ColorOpts.new()
		if pretty_opts.disable_colors:
			color_opts.no_color()

	if not pretty_opts.show_prefix:
		return ""

	# prefixes
	var logger_name = prefix_logger_name()
	var timestamp = prefix_timestamp()
	var pid = prefix_process_id()
	var callsite = prefix_callsite(pretty_opts, color_opts)

	# TODO we could expose this format string to support more prefix customization (reordering)
	return "{logger_name}{timestamp}{pid}{callsite}".format({
		logger_name=logger_name,
		timestamp=timestamp,
		pid=pid,
		callsite=callsite,
		})


################
# to_printable #
################


## Formats the args passed to public Log functions for printing, supporting a few options.
##
## [br][br]
## This function mostly depends on to_pretty, but also adds the prefix itself.
##
## [br][br]
## See also some common variants: [method to_printable_colorless], [method to_printable_simple].
func to_printable(msgs: Array, opts: Dictionary = {}) -> String:
	if not config.is_config_setup:
		LogConfig.rebuild_config(config)
	return _to_printable(msgs, PrettyOpts.new(opts))


func _to_printable(msgs: Array, pretty_opts: PrettyOpts, color_opts: ColorOpts = null) -> String:
	# should we apply the config on every to_printable?
	pretty_opts.apply_config(config)

	if color_opts == null:
		color_opts = ColorOpts.new()
		if pretty_opts.disable_colors:
			color_opts.no_color()

	var m: String = build_prefix(pretty_opts, color_opts)

	if not msgs is Array:
		msgs = [msgs]
	for msg: Variant in msgs:
		# add a space between msgs
		m += "%s " % _to_pretty(msg, pretty_opts, color_opts)

	return m.trim_suffix(" ")


## Variant of to_printable that disables colors.
func to_printable_colorless(msgs: Array) -> String:
	return _to_printable(msgs, PrettyOpts.new({}).no_color())


## Variant of to_printable that disables the prefix and colors completely.
func to_printable_simple(msgs: Array) -> String:
	return _to_printable(msgs, PrettyOpts.simple())


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
func pr(...msgs: Array) -> void:
	print_rich(to_printable(msgs))


## Pretty-print the passed arguments in a single line.
##
## An alias for `pr`
func log(...msgs: Array) -> void:
	print_rich(to_printable(msgs))


## Pretty-print the passed arguments, expanding dictionaries and arrays with a newline and indentation.
func prn(...msgs: Array) -> void:
	print_rich(_to_printable(msgs, PrettyOpts.with_depth(1)))


## Pretty-print the passed arguments, expanding dictionaries and arrays with two newlines and indentation.
func prnn(...msgs: Array) -> void:
	print_rich(_to_printable(msgs, PrettyOpts.with_depth(2)))


## Pretty-print the passed arguments, expanding dictionaries and arrays with three newlines and indentation.
func prnnn(...msgs: Array) -> void:
	print_rich(_to_printable(msgs, PrettyOpts.with_depth(3)))


## Pretty-print the passed arguments in a single line.
func debug(...msgs: Array) -> void:
	if config.get_log_level() > Log.Levels.DEBUG:
		return
	print_rich("[DEBUG] " + to_printable(msgs))


## Pretty-print the passed arguments in a single line.
func info(...msgs: Array) -> void:
	if config.get_log_level() > Log.Levels.INFO:
		return
	print_rich("[INFO] " + to_printable(msgs))


## Like [code]Log.pr()[/code], but also calls push_warning() with the pretty string.
func warn(...msgs: Array) -> void:
	if config.get_log_level() > Log.Levels.WARN:
		return
	print_rich("[color=yellow][WARN][/color] " + to_printable(msgs))
	push_warning(to_printable_colorless(msgs))


## Like [code]Log.pr()[/code], but prepends a "[TODO]" and calls push_warning() with the pretty string.
##
## Pretty cool - lets you use the warnings tab as a TODO list!
func todo(...msgs: Array) -> void:
	if config.get_warn_todo() and config.get_log_level() > Log.Levels.WARN:
		return
	elif not config.get_warn_todo() and config.get_log_level() > Log.Levels.INFO:
		return
	var m: String = "[TODO] " + to_printable(msgs)
	if config.get_warn_todo():
		m = "[color=yellow][WARN][/color] " + m
	print_rich(m)
	if config.get_warn_todo():
		push_warning(to_printable_colorless(msgs))


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty string.
func err(...msgs: Array) -> void:
	print_rich("[color=red][ERR][/color] " + to_printable(msgs))
	push_error(to_printable_colorless(msgs))


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty string.
func error(...msgs: Array) -> void:
	print_rich("[color=red][ERR][/color] " + to_printable(msgs))
	push_error(to_printable_colorless(msgs))


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
		print_rich(to_printable([msg]))
		return

	if config.columns == [] \
	and typeof(msg) == TYPE_ARRAY \
	and typeof(msg[0]) not in [TYPE_DICTIONARY, TYPE_OBJECT]:
		print_rich(to_printable(msg))
		return

	print_rich(build_prefix(PrettyOpts.new({})))

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
				longest_values[i] = max(longest_values[i], LogTable.item_width(item[i]))
	elif typeof(msg[0]) == TYPE_DICTIONARY:
		for item: Dictionary in msg:
			var item_values: Array = item.values()
			for i in range(len(item_values)):
				longest_values[i] = max(longest_values[i], LogTable.item_width(item_values[i]))
	elif typeof(msg[0]) == TYPE_OBJECT:
		for item: Object in msg:
			for i in range(len(config.columns)):
				longest_values[i] = max(longest_values[i], LogTable.item_width(item.get(config.columns[i])))
	else:
		for i in range(len(msg)):
			longest_values[i] = max(longest_values[i], LogTable.item_width(msg[i]))

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
func _internal_debug(...msgs: Array) -> void:
	var m: String = to_printable(msgs)
	print("_internal_debug: ", m)
	print_rich(m)
