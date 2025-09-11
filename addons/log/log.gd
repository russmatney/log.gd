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
##

@tool
extends Object
class_name Log

# helpers ####################################

static func assoc(opts: Dictionary, key: String, val: Variant) -> Dictionary:
	var _opts: Dictionary = opts.duplicate(true)
	_opts[key] = val
	return _opts

# settings helpers ####################################

static func initialize_setting(key: String, default_value: Variant, type: int, hint: int = PROPERTY_HINT_NONE, hint_string: String = "") -> void:
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set(key, default_value)
	ProjectSettings.set_initial_value(key, default_value)
	ProjectSettings.add_property_info({name=key, type=type, hint=hint, hint_string=hint_string})

# settings keys and default ####################################

const KEY_PREFIX: String = "log_gd/config"
static var is_config_setup: bool = false

# TODO drop this key
const KEY_COLOR_THEME_DICT: String = "log_color_theme_dict"
const KEY_COLOR_THEME: String = "log_color_theme"
const KEY_COLOR_THEME_RESOURCE_PATH: String = "%s/color_resource_path" % KEY_PREFIX
const KEY_DISABLE_COLORS: String = "%s/disable_colors" % KEY_PREFIX
const KEY_MAX_ARRAY_SIZE: String = "%s/max_array_size" % KEY_PREFIX
const KEY_SKIP_KEYS: String = "%s/dictionary_skip_keys" % KEY_PREFIX
const KEY_USE_NEWLINES: String = "%s/use_newlines" % KEY_PREFIX
const KEY_NEWLINE_MAX_DEPTH: String = "%s/newline_max_depth" % KEY_PREFIX
const KEY_LOG_LEVEL: String = "%s/log_level" % KEY_PREFIX
const KEY_WARN_TODO: String = "%s/warn_todo" % KEY_PREFIX
const KEY_SHOW_LOG_LEVEL_SELECTOR: String = "%s/show_log_level_selector" % KEY_PREFIX
const KEY_SHOW_TIMESTAMPS: String = "%s/show_timestamps" % KEY_PREFIX
const KEY_TIMESTAMP_TYPE: String = "%s/timestamp_type" % KEY_PREFIX
const KEY_HUMAN_READABLE_TIMESTAMP_FORMAT: String = "%s/human_readable_timestamp_format" % KEY_PREFIX

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

const CONFIG_DEFAULTS := {
		KEY_COLOR_THEME_RESOURCE_PATH: "res://addons/log/color_theme_dark.tres",
		KEY_DISABLE_COLORS: false,
		KEY_MAX_ARRAY_SIZE: 20,
		KEY_SKIP_KEYS: ["layer_0/tile_data"],
		KEY_USE_NEWLINES: false,
		KEY_NEWLINE_MAX_DEPTH: -1,
		KEY_LOG_LEVEL: Levels.INFO,
		KEY_WARN_TODO: true,
		KEY_SHOW_LOG_LEVEL_SELECTOR: false,
		KEY_SHOW_TIMESTAMPS: false,
		KEY_TIMESTAMP_TYPE: TimestampTypes.HUMAN_12HR,
		KEY_HUMAN_READABLE_TIMESTAMP_FORMAT: "{hour}:{minute}:{second}",
	}

# settings setup ####################################

static func setup_settings(opts: Dictionary = {}) -> void:
	initialize_setting(KEY_COLOR_THEME_RESOURCE_PATH, CONFIG_DEFAULTS[KEY_COLOR_THEME_RESOURCE_PATH], TYPE_STRING, PROPERTY_HINT_FILE)
	initialize_setting(KEY_DISABLE_COLORS, CONFIG_DEFAULTS[KEY_DISABLE_COLORS], TYPE_BOOL)
	initialize_setting(KEY_MAX_ARRAY_SIZE, CONFIG_DEFAULTS[KEY_MAX_ARRAY_SIZE], TYPE_INT)
	initialize_setting(KEY_SKIP_KEYS, CONFIG_DEFAULTS[KEY_SKIP_KEYS], TYPE_PACKED_STRING_ARRAY)
	initialize_setting(KEY_USE_NEWLINES, CONFIG_DEFAULTS[KEY_USE_NEWLINES], TYPE_BOOL)
	initialize_setting(KEY_NEWLINE_MAX_DEPTH, CONFIG_DEFAULTS[KEY_NEWLINE_MAX_DEPTH], TYPE_INT)
	initialize_setting(KEY_LOG_LEVEL, CONFIG_DEFAULTS[KEY_LOG_LEVEL], TYPE_INT, PROPERTY_HINT_ENUM, "DEBUG,INFO,WARN,ERROR")
	initialize_setting(KEY_WARN_TODO, CONFIG_DEFAULTS[KEY_WARN_TODO], TYPE_BOOL)
	initialize_setting(KEY_SHOW_LOG_LEVEL_SELECTOR, CONFIG_DEFAULTS[KEY_SHOW_LOG_LEVEL_SELECTOR], TYPE_BOOL)
	initialize_setting(KEY_SHOW_TIMESTAMPS, CONFIG_DEFAULTS[KEY_SHOW_TIMESTAMPS], TYPE_BOOL)
	initialize_setting(KEY_TIMESTAMP_TYPE, CONFIG_DEFAULTS[KEY_TIMESTAMP_TYPE], TYPE_INT, PROPERTY_HINT_ENUM, "UNIX,TICKS_MSEC,TICKS_USEC,HUMAN_12HR,HUMAN_24HR")
	initialize_setting(KEY_HUMAN_READABLE_TIMESTAMP_FORMAT, CONFIG_DEFAULTS[KEY_HUMAN_READABLE_TIMESTAMP_FORMAT], TYPE_STRING)

# config setup ####################################

static var config: Dictionary = {}
static func rebuild_config(opts: Dictionary = {}) -> void:
	for key: String in CONFIG_DEFAULTS.keys():
		# Keep config set in code before to_printable() is called for the first time
		var val: Variant = Log.config.get(key, ProjectSettings.get_setting(key, CONFIG_DEFAULTS[key]))

		Log.config[key] = val

		# hardcoding a resource-load b/c it seems like custom-resources can't be loaded by the project settings
		# https://github.com/godotengine/godot/issues/96219
		if val != null and key == KEY_COLOR_THEME_RESOURCE_PATH:
			Log.config[KEY_COLOR_THEME] = load(val)
			Log.config[KEY_COLOR_THEME_DICT] = Log.config[KEY_COLOR_THEME].to_color_dict()

	Log.is_config_setup = true

# config getters ###################################################################

static func get_max_array_size() -> int:
	return Log.config.get(KEY_MAX_ARRAY_SIZE, CONFIG_DEFAULTS[KEY_MAX_ARRAY_SIZE])

static func get_dictionary_skip_keys() -> Array:
	return Log.config.get(KEY_SKIP_KEYS, CONFIG_DEFAULTS[KEY_SKIP_KEYS])

static func get_disable_colors() -> bool:
	return Log.config.get(KEY_DISABLE_COLORS, CONFIG_DEFAULTS[KEY_DISABLE_COLORS])

# TODO refactor away from the dict, create a termsafe LogColorTheme fallback
static var warned_about_termsafe_fallback := false
static func get_config_color_theme_dict() -> Dictionary:
	var color_theme = Log.config.get(KEY_COLOR_THEME)
	var color_dict = Log.config.get(KEY_COLOR_THEME_DICT)
	if color_dict != null:
		return color_dict
	if not warned_about_termsafe_fallback:
		print("Falling back to TERM_SAFE colors")
		warned_about_termsafe_fallback = true
	return LogColorTheme.COLORS_TERM_SAFE

static func get_config_color_theme() -> LogColorTheme:
	var color_theme = Log.config.get(KEY_COLOR_THEME)
	# TODO better warnings, fallbacks
	return color_theme

static func get_use_newlines() -> bool:
	return Log.config.get(KEY_USE_NEWLINES, CONFIG_DEFAULTS[KEY_USE_NEWLINES])

static func get_newline_max_depth() -> int:
	return Log.config.get(KEY_NEWLINE_MAX_DEPTH, CONFIG_DEFAULTS[KEY_NEWLINE_MAX_DEPTH])

static func get_log_level() -> int:
	return Log.config.get(KEY_LOG_LEVEL, CONFIG_DEFAULTS[KEY_LOG_LEVEL])

static func get_warn_todo() -> int:
	return Log.config.get(KEY_WARN_TODO, CONFIG_DEFAULTS[KEY_WARN_TODO])

static func get_show_timestamps() -> bool:
	return Log.config.get(KEY_SHOW_TIMESTAMPS, CONFIG_DEFAULTS[KEY_SHOW_TIMESTAMPS])

static func get_timestamp_type() -> TimestampTypes:
	return Log.config.get(KEY_TIMESTAMP_TYPE, CONFIG_DEFAULTS[KEY_TIMESTAMP_TYPE])

static func get_timestamp_format() -> String:
	return Log.config.get(KEY_HUMAN_READABLE_TIMESTAMP_FORMAT, CONFIG_DEFAULTS[KEY_HUMAN_READABLE_TIMESTAMP_FORMAT])


## config setters ###################################################################

## Disable color-wrapping output.
##
## [br][br]
## Useful to declutter the output if the environment does not support colors.
## Note that some environments support only a subset of colors - you may prefer
## [code]set_colors_termsafe()[/code].
static func disable_colors() -> void:
	Log.config[KEY_DISABLE_COLORS] = true

## Re-enable color-wrapping output.
static func enable_colors() -> void:
	Log.config[KEY_DISABLE_COLORS] = false

## Disable newlines in pretty-print output.
##
## [br][br]
## Useful if you want your log output on a single line, typically for use with
## log aggregation tools.
static func disable_newlines() -> void:
	Log.config[KEY_USE_NEWLINES] = false

## Re-enable newlines in pretty-print output.
static func enable_newlines() -> void:
	Log.config[KEY_USE_NEWLINES] = true

## Disable warning on Log.todo().
static func disable_warn_todo() -> void:
	Log.config[KEY_WARN_TODO] = false

## Re-enable warning on Log.todo().
static func enable_warn_todo() -> void:
	Log.config[KEY_WARN_TODO] = true

## Set the maximum depth of an object that will get its own newline.
##
## [br][br]
## Useful if you have deeply nested objects where you're primarly interested
## in easily parsing the information near the root of the object.
static func set_newline_max_depth(new_depth: int) -> void:
	Log.config[KEY_NEWLINE_MAX_DEPTH] = new_depth

## Resets the maximum object depth for newlines to the default.
static func reset_newline_max_depth() -> void:
	Log.config[KEY_USE_NEWLINES] = CONFIG_DEFAULTS[KEY_NEWLINE_MAX_DEPTH]

## Set the minimum level of logs that get printed
static func set_log_level(new_log_level: int) -> void:
	Log.config[KEY_LOG_LEVEL] = new_log_level

## Show timestamps in log lines
static func show_timestamps() -> void:
	Log.config[KEY_SHOW_TIMESTAMPS] = true

## Don't timestamps in log lines
static func hide_timestamps() -> void:
	Log.config[KEY_SHOW_TIMESTAMPS] = false

## Use the given timestamp type
static func use_timestamp_type(timestamp_type: Log.TimestampTypes) -> void:
	Log.config[KEY_TIMESTAMP_TYPE] = timestamp_type

## Use the given timestamp format
static func use_timestamp_format(timestamp_format: String) -> void:
	Log.config[KEY_HUMAN_READABLE_TIMESTAMP_FORMAT] = timestamp_format

## set color theme ####################################

## Use the terminal safe color scheme, which should support colors in most tty-like environments.
static func set_colors_termsafe() -> void:
	Log.config[KEY_COLOR_THEME_DICT] = LogColorTheme.COLORS_TERM_SAFE

## Use prettier colors - i.e. whatever LogColorTheme is configured.
static func set_colors_pretty() -> void:
	var theme_path: Variant = Log.config.get(KEY_COLOR_THEME_RESOURCE_PATH)
	# TODO proper string, file, resource load check here
	if theme_path != null:
		Log.config[KEY_COLOR_THEME] = load(theme_path)
		Log.config[KEY_COLOR_THEME_DICT] = Log.config[KEY_COLOR_THEME].to_color_dict()
	else:
		print("WARNING no color theme resource path to load!")

## applying colors ####################################

static func should_use_color(opts: Dictionary = {}) -> bool:
	if OS.has_feature("ios") or OS.has_feature("web"):
		# ios and web (and likely others) don't handle colors well
		return false
	if Log.get_disable_colors():
		return false
	# supports per-print color skipping
	if opts.get("disable_colors", false):
		return false
	return true

static func color_wrap(s: Variant, opts: Dictionary = {}) -> String:
	# TODO refactor to use the color theme directly
	var colors: Dictionary = get_config_color_theme_dict()
	var color_theme: LogColorTheme = get_config_color_theme()

	if not should_use_color(opts):
		return str(s)

	var color: Variant = opts.get("color", "")
	if color == null or (color is String and color == ""):
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

	if color is String and color == "" or color == null:
		print("Log.gd could not determine color for object: %s type: (%s)" % [str(s), typeof(s)])

	if color is Array:
		# support rainbow delimiters
		if opts.get("typeof", "") in ["dict_key"]:
			# subtract 1 for dict_keys
			# we the keys are 'down' a nesting level, but we want the curly + dict keys to match
			color = color[opts.get("newline_depth", 0) - 1 % len(color)]
		else:
			color = color[opts.get("newline_depth", 0) % len(color)]

	if color is Color:
		# get the colors back to something bb_code can handle
		color = color.to_html(false)

	if color_theme and color_theme.has_bg():
		var bg_color: String = color_theme.get_bg_color(opts.get("newline_depth", 0)).to_html(false)
		return "[bgcolor=%s][color=%s]%s[/color][/bgcolor]" % [bg_color, color, s]
	return "[color=%s]%s[/color]" % [color, s]

## overwrites ###########################################################################

static var type_overwrites: Dictionary = {}

## Register a single type overwrite.
##
## [br][br]
## The key should be either obj.get_class() or typeof(var). (Note that using typeof(var) may overwrite more broadly than expected).
##
## [br][br]
## The handler is called with the object and an options dict.
## [code]func(obj): return {name=obj.name}[/code]
static func register_type_overwrite(key: String, handler: Callable) -> void:
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
static func register_type_overwrites(overwrites: Dictionary) -> void:
	type_overwrites.merge(overwrites, true)

static func clear_type_overwrites() -> void:
	type_overwrites = {}

## to_pretty ###########################################################################

## Returns the passed object as a bb-colorized string.
##
## [br][br]
## The core of Log.gd's functionality.
##
## [br][br]
## Can be useful to feed directly into a RichTextLabel.
##
static func to_pretty(msg: Variant, opts: Dictionary = {}) -> String:
	var newlines: bool = opts.get("newlines", Log.get_use_newlines())
	var newline_depth: int = opts.get("newline_depth", 0)
	var newline_max_depth: int = opts.get("newline_max_depth", Log.get_newline_max_depth())
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
		return Log.color_wrap(msg, opts)

	if msg is Object and (msg as Object).get_class() in type_overwrites:
		var fn: Callable = type_overwrites.get((msg as Object).get_class())
		return Log.to_pretty(fn.call(msg), opts)
	elif typeof(msg) in type_overwrites:
		var fn: Callable = type_overwrites.get(typeof(msg))
		return Log.to_pretty(fn.call(msg), opts)

	# objects
	if msg is Object and (msg as Object).has_method("to_pretty"):
		# using a cast and `call.("blah")` here it's "type safe"
		return Log.to_pretty((msg as Object).call("to_pretty"), opts)
	if msg is Object and (msg as Object).has_method("data"):
		return Log.to_pretty((msg as Object).call("data"), opts)
	# DEPRECATED
	if msg is Object and (msg as Object).has_method("to_printable"):
		return Log.to_pretty((msg as Object).call("to_printable"), opts)

	# arrays
	if msg is Array or msg is PackedStringArray:
		var msg_array: Array = msg
		if len(msg) > Log.get_max_array_size():
			pr("[DEBUG]: truncating large array. total:", len(msg))
			msg_array = msg_array.slice(0, Log.get_max_array_size() - 1)
			if newlines:
				msg_array.append("...")

		# shouldn't we be incrementing index_level here?
		var tmp: String = Log.color_wrap("[ ", opts)
		opts["newline_depth"] += 1
		var last: int = len(msg) - 1
		for i: int in range(len(msg)):
			if newlines and last > 1:
				tmp += Log.color_wrap("\n\t", opts)
			tmp += Log.to_pretty(msg[i],
				# duplicate here to prevent indenting-per-msg
				# e.g. when printing an array of dictionaries
				opts.duplicate(true))
			if i != last:
				tmp += Log.color_wrap(", ", opts)
		opts["newline_depth"] -= 1
		tmp += Log.color_wrap(" ]", opts)
		return tmp

	# dictionary
	elif msg is Dictionary:
		var tmp: String = Log.color_wrap("{ ", opts)
		opts["newline_depth"] += 1
		var ct: int = len(msg)
		var last: Variant
		if len(msg) > 0:
			last = (msg as Dictionary).keys()[-1]
		var indent_updated = false
		for k: Variant in (msg as Dictionary).keys():
			var val: Variant
			if k in Log.get_dictionary_skip_keys():
				val = "..."
			else:
				if not indent_updated:
					indent_updated = true
					opts["indent_level"] += 1
				val = Log.to_pretty(msg[k], opts)
			if newlines and ct > 1:
				tmp += Log.color_wrap("\n\t", opts) \
					+ Log.color_wrap(range(indent_level)\
					.map(func(_i: int) -> String: return "\t")\
					.reduce(func(a: String, b: Variant) -> String: return str(a, b), ""), opts)
			var key: String = Log.color_wrap('"%s"' % k, Log.assoc(opts, "typeof", "dict_key"))
			tmp += "%s%s%s" % [key, Log.color_wrap(": ", opts), val]
			if last and str(k) != str(last):
				tmp += Log.color_wrap(", ", opts)
		opts["newline_depth"] -= 1
		tmp += Log.color_wrap(" }", opts)
		opts["indent_level"] -= 1 # ugh! updating the dict in-place
		return tmp

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
		return Log.color_wrap(msg.to_html(false), Log.assoc(opts, "typeof", TYPE_COLOR))

	# vectors
	elif msg is Vector2 or msg is Vector2i:
		return '%s%s%s%s%s' % [
			Log.color_wrap("(", opts),
			Log.color_wrap(msg.x, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(",", opts),
			Log.color_wrap(msg.y, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(")", opts),
		]

	elif msg is Vector3 or msg is Vector3i:
		return '%s%s%s%s%s%s%s' % [
			Log.color_wrap("(", opts),
			Log.color_wrap(msg.x, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(",", opts),
			Log.color_wrap(msg.y, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(",", opts),
			Log.color_wrap(msg.z, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(")", opts),
			]
	elif msg is Vector4 or msg is Vector4i:
		return '%s%s%s%s%s%s%s%s%s' % [
			Log.color_wrap("(", opts),
			Log.color_wrap(msg.x, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(",", opts),
			Log.color_wrap(msg.y, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(",", opts),
			Log.color_wrap(msg.z, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(",", opts),
			Log.color_wrap(msg.w, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(")", opts),
			]

	# packed scene
	elif msg is PackedScene:
		var msg_ps: PackedScene = msg
		if msg_ps.resource_path != "":
			return str(Log.color_wrap("PackedScene:", opts), '%s' % msg_ps.resource_path.get_file())
		elif msg_ps.get_script() != null and msg_ps.get_script().resource_path != "":
			var path: String = msg_ps.get_script().resource_path
			return Log.color_wrap(path.get_file(), Log.assoc(opts, "typeof", "class_name"))
		else:
			return Log.color_wrap(msg_ps, opts)

	# resource
	elif msg is Resource:
		var msg_res: Resource = msg
		if msg_res.get_script() != null and msg_res.get_script().resource_path != "":
			var path: String = msg_res.get_script().resource_path
			return Log.color_wrap(path.get_file(), Log.assoc(opts, "typeof", "class_name"))
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
			return Log.color_wrap(path.get_file(), Log.assoc(opts, "typeof", "class_name"))
		else:
			return Log.color_wrap(msg_ref.get_class(), Log.assoc(opts, "typeof", "class_name"))

	# fallback to primitive-type lookup
	else:
		return Log.color_wrap(msg, opts)

## to_printable ###########################################################################

static func log_prefix(stack: Array) -> String:
	if len(stack) > 1:
		var call_site: Dictionary = stack[1]
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

static func to_printable(msgs: Array, opts: Dictionary = {}) -> String:
	if not Log.is_config_setup:
		rebuild_config()

	if not msgs is Array:
		msgs = [msgs]
	var stack: Array = opts.get("stack", [])
	var pretty: bool = opts.get("pretty", true)
	var m: String = ""
	if get_show_timestamps():
		m = "[%s]" % Log.timestamp()
	if len(stack) > 0:
		var prefix: String = Log.log_prefix(stack)
		var prefix_type: String
		if prefix != null and prefix[0] == "[":
			prefix_type = "SRC"
		elif prefix != null and prefix[0] == "{":
			prefix_type = "TEST"
		elif prefix != null and prefix[0] == "<":
			prefix_type = "ADDONS"
		if pretty:
			m += Log.color_wrap(prefix, Log.assoc(opts, "typeof", prefix_type))
		else:
			m += prefix
	for msg: Variant in msgs:
		# add a space between msgs
		if pretty:
			m += "%s " % Log.to_pretty(msg, opts)
		else:
			m += "%s " % str(msg)
	return m.trim_suffix(" ")

static func timestamp() -> String:
	match Log.get_timestamp_type():
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
			return Log.get_timestamp_format().format({
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
			return Log.get_timestamp_format().format({
					"year": time.year,
					"month": "%02d" % time.month,
					"day": "%02d" % time.day,
					"hour": "%02d" % time.hour,
					"minute": "%02d" % time.minute,
					"second": "%02d" % time.second,
					"dst": time.dst
				})
	return "%d" % Time.get_unix_time_from_system()

## public print fns ###########################################################################

static func is_not_default(v: Variant) -> bool:
	return not v is String or (v is String and v != "ZZZDEF")

## Pretty-print the passed arguments in a single line.
static func pr(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

## Pretty-print the passed arguments, expanding dictionaries and arrays with a newline and indentation.
static func prn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack(), newlines=true, newline_max_depth=1})
	print_rich(m)

## Pretty-print the passed arguments, expanding dictionaries and arrays with two newlines and indentation.
static func prnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack(), newlines=true, newline_max_depth=2})
	print_rich(m)

## Pretty-print the passed arguments, expanding dictionaries and arrays with three newlines and indentation.
static func prnnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack(), newlines=true, newline_max_depth=3})
	print_rich(m)

## Pretty-print the passed arguments in a single line.
static func log(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

## Pretty-print the passed arguments in a single line.
static func debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if get_log_level() > Log.Levels.DEBUG:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	msgs.push_front("[DEBUG]")
	var m: String = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

## Pretty-print the passed arguments in a single line.
static func info(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if get_log_level() > Log.Levels.INFO:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	msgs.push_front("[INFO]")
	var m: String = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

## Like [code]Log.pr()[/code], but also calls push_warning() with the pretty string.
static func warn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if get_log_level() > Log.Levels.WARN:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack()}))
	# skip the 'color' features in warnings to keep them readable in the debugger
	var m: String = Log.to_printable(msgs, {stack=get_stack(), disable_colors=true})
	push_warning(m)

## Like [code]Log.pr()[/code], but prepends a "[TODO]" and calls push_warning() with the pretty string.
static func todo(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if get_warn_todo() and get_log_level() > Log.Levels.WARN:
		return
	elif not get_warn_todo() and get_log_level() > Log.Levels.INFO:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	msgs.push_front("[TODO]")
	var rich_msgs: Array = msgs.duplicate()
	if get_warn_todo():
		rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack()}))
	if get_warn_todo():
		var m: String = Log.to_printable(msgs, {stack=get_stack(), disable_colors=true})
		push_warning(m)

## Like [code]Log.pr()[/code], but also calls push_error() with the pretty string.
static func err(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack()}))
	# skip the 'color' features in errors to keep them readable in the debugger
	var m: String = Log.to_printable(msgs, {stack=get_stack(), disable_colors=true})
	push_error(m)

## Like [code]Log.pr()[/code], but also calls push_error() with the pretty string.
static func error(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack()}))
	# skip the 'color' features in errors to keep them readable in the debugger
	var m: String = Log.to_printable(msgs, {stack=get_stack(), disable_colors=true})
	push_error(m)

static func blank() -> void:
	print()


## Helper that will both print() and print_rich() the enriched string
static func _internal_debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack()})
	print("_internal_debug: ", m)
	print_rich(m)


## DEPRECATED
static func merge_theme_overwrites(_opts = {}) -> void:
	pass

## DEPRECATED
static func clear_theme_overwrites() -> void:
	pass
