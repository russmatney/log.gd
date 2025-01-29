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
## You can find up to date docs and examples in the Log.gd repo and docs site:
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

# config ####################################

const KEY_PREFIX: String = "log_gd/config"
static var is_config_setup: bool = false

const KEY_COLOR_THEME: String = "%s/color_theme" % KEY_PREFIX
const KEY_DISABLE_COLORS: String = "%s/disable_colors" % KEY_PREFIX
const KEY_MAX_ARRAY_SIZE: String = "%s/max_array_size" % KEY_PREFIX
const KEY_SKIP_KEYS: String = "%s/dictionary_skip_keys" % KEY_PREFIX

static func setup_config(opts: Dictionary = {}) -> void:
	var keys: Array = opts.get("keys", [
		KEY_COLOR_THEME,
		KEY_DISABLE_COLORS,
		KEY_MAX_ARRAY_SIZE,
		KEY_SKIP_KEYS,
		])

	for key: String in keys:
		if ProjectSettings.has_setting(key):
			Log.config[key] = ProjectSettings.get_setting(key)
		else:
			var val: Variant = Log.config[key]
			if val != null:
				ProjectSettings.set_setting(key, val)
				ProjectSettings.set_initial_value(key, val)

	Log.is_config_setup = true

static var config: Dictionary = {
	KEY_COLOR_THEME: LOG_THEME_TERMSAFE,
	KEY_DISABLE_COLORS: false,
	KEY_MAX_ARRAY_SIZE: 20,
	KEY_SKIP_KEYS: [
		"layer_0/tile_data", # skip huge tilemap arrays
		],
	}

# config getters ###################################################################

static func get_max_array_size() -> int:
	return Log.config.get(KEY_MAX_ARRAY_SIZE, 20)

static func get_dictionary_skip_keys() -> Array:
	return Log.config.get(KEY_SKIP_KEYS, [])

static func get_disable_colors() -> bool:
	return Log.config.get(KEY_DISABLE_COLORS, false)

static func get_config_color_theme() -> Dictionary:
	var theme_id: String = Log.config.get(KEY_COLOR_THEME, LOG_THEME_TERMSAFE)
	match theme_id:
		LOG_THEME_TERMSAFE:
			return Log.COLORS_TERMINAL_SAFE
		LOG_THEME_PRETTY_V1:
			return Log.COLORS_PRETTY_V1
		_:
			print("Unknown LOG_THEME '%s', using fallback" % theme_id)
			return Log.COLORS_TERMINAL_SAFE

# config setters ###################################################################

## Disable color-wrapping output.
##
## [br][br]
## Useful to declutter the output if the environment does not support colors.
## Note that some environments support only a subset of colors - you may prefer
## [code]set_colors_termsafe()[/code] or otherwise setting the theme to 'TERMSAFE'.
static func disable_colors() -> void:
	Log.config[KEY_DISABLE_COLORS] = true

## Re-enable color-wrapping output.
static func enable_colors() -> void:
	Log.config[KEY_DISABLE_COLORS] = false

## DEPRECATED
static func set_color_scheme(theme: String) -> void:
	set_color_theme(theme)

static func set_color_theme(theme: String) -> void:
	Log.config[KEY_COLOR_THEME] = theme

## colors ###########################################################################

# terminal safe colors:
# - black
# - red
# - green
# - yellow
# - blue
# - magenta
# - pink
# - purple
# - cyan
# - white
# - orange
# - gray

const LOG_THEME_TERMSAFE: String = "TERMSAFE"
const LOG_THEME_PRETTY_V1: String = "PRETTY_V1"

static var COLORS_TERMINAL_SAFE: Dictionary = {
	"SRC": "cyan",
	"ADDONS": "red",
	"TEST": "green",
	",": "red",
	"(": "red",
	")": "red",
	"[": "red",
	"]": "red",
	"{": "red",
	"}": "red",
	"&": "orange",
	"^": "orange",
	"dict_key": "magenta",
	"vector_value": "green",
	"class_name": "magenta",
	TYPE_NIL: "pink",
	TYPE_BOOL: "pink",
	TYPE_INT: "green",
	TYPE_FLOAT: "green",
	TYPE_STRING: "pink",
	TYPE_VECTOR2: "green",
	TYPE_VECTOR2I: "green",
	TYPE_RECT2: "green",
	TYPE_RECT2I: "green",
	TYPE_VECTOR3: "green",
	TYPE_VECTOR3I: "green",
	TYPE_TRANSFORM2D: "pink",
	TYPE_VECTOR4: "green",
	TYPE_VECTOR4I: "green",
	TYPE_PLANE: "pink",
	TYPE_QUATERNION: "pink",
	TYPE_AABB: "pink",
	TYPE_BASIS: "pink",
	TYPE_TRANSFORM3D: "pink",
	TYPE_PROJECTION: "pink",
	TYPE_COLOR: "pink",
	TYPE_STRING_NAME: "pink",
	TYPE_NODE_PATH: "pink",
	TYPE_RID: "pink",
	TYPE_OBJECT: "pink",
	TYPE_CALLABLE: "pink",
	TYPE_SIGNAL: "pink",
	TYPE_DICTIONARY: "pink",
	TYPE_ARRAY: "pink",
	TYPE_PACKED_BYTE_ARRAY: "pink",
	TYPE_PACKED_INT32_ARRAY: "pink",
	TYPE_PACKED_INT64_ARRAY: "pink",
	TYPE_PACKED_FLOAT32_ARRAY: "pink",
	TYPE_PACKED_FLOAT64_ARRAY: "pink",
	TYPE_PACKED_STRING_ARRAY: "pink",
	TYPE_PACKED_VECTOR2_ARRAY: "pink",
	TYPE_PACKED_VECTOR3_ARRAY: "pink",
	TYPE_PACKED_COLOR_ARRAY: "pink",
	TYPE_MAX: "pink",
	}

static var COLORS_PRETTY_V1: Dictionary = {
	"SRC": "aquamarine",
	"ADDONS": "peru",
	"TEST": "green_yellow",
	",": "crimson",
	"(": "crimson",
	")": "crimson",
	"[": "crimson",
	"]": "crimson",
	"{": "crimson",
	"}": "crimson",
	"&": "coral",
	"^": "coral",
	"dict_key": "cadet_blue",
	"vector_value": "cornflower_blue",
	"class_name": "cadet_blue",
	TYPE_NIL: "coral",
	TYPE_BOOL: "pink",
	TYPE_INT: "cornflower_blue",
	TYPE_FLOAT: "cornflower_blue",
	TYPE_STRING: "dark_gray",
	TYPE_VECTOR2: "cornflower_blue",
	TYPE_VECTOR2I: "cornflower_blue",
	TYPE_RECT2: "cornflower_blue",
	TYPE_RECT2I: "cornflower_blue",
	TYPE_VECTOR3: "cornflower_blue",
	TYPE_VECTOR3I: "cornflower_blue",
	TYPE_TRANSFORM2D: "pink",
	TYPE_VECTOR4: "cornflower_blue",
	TYPE_VECTOR4I: "cornflower_blue",
	TYPE_PLANE: "pink",
	TYPE_QUATERNION: "pink",
	TYPE_AABB: "pink",
	TYPE_BASIS: "pink",
	TYPE_TRANSFORM3D: "pink",
	TYPE_PROJECTION: "pink",
	TYPE_COLOR: "pink",
	TYPE_STRING_NAME: "pink",
	TYPE_NODE_PATH: "pink",
	TYPE_RID: "pink",
	TYPE_OBJECT: "pink",
	TYPE_CALLABLE: "pink",
	TYPE_SIGNAL: "pink",
	TYPE_DICTIONARY: "pink",
	TYPE_ARRAY: "pink",
	TYPE_PACKED_BYTE_ARRAY: "pink",
	TYPE_PACKED_INT32_ARRAY: "pink",
	TYPE_PACKED_INT64_ARRAY: "pink",
	TYPE_PACKED_FLOAT32_ARRAY: "pink",
	TYPE_PACKED_FLOAT64_ARRAY: "pink",
	TYPE_PACKED_STRING_ARRAY: "pink",
	TYPE_PACKED_VECTOR2_ARRAY: "pink",
	TYPE_PACKED_VECTOR3_ARRAY: "pink",
	TYPE_PACKED_COLOR_ARRAY: "pink",
	TYPE_MAX: "pink",
	}

## set color theme ####################################

## Use the terminal safe color scheme, which should handle colors in most tty-like environments.
static func set_colors_termsafe() -> void:
	set_color_theme(LOG_THEME_TERMSAFE)

## Use prettier colors - looks nice in most dark godot themes.
##
## [br][br]
## Hopefully we'll support more themes (including light themes) soon!
static func set_colors_pretty() -> void:
	set_color_theme(LOG_THEME_PRETTY_V1)

static var theme_overwrites: Dictionary = {}

## Merge per type color adjustments.
##
## [br][br]
## Expects a Dictionary from [code]{typeof(obj): Color}[/code].
## See [code]COLORS_TERMINAL_SAFE[/code] for an example.
static func merge_theme_overwrites(colors: Dictionary) -> void:
	theme_overwrites.merge(colors, true)

static func clear_theme_overwrites() -> void:
	theme_overwrites = {}

static func get_color_theme(opts: Dictionary = {}) -> Dictionary:
	var theme: Dictionary = opts.get("color_theme", {})
	# fill in any missing vals with the set theme, then the term-safe fallbacks
	theme.merge(Log.theme_overwrites)
	theme.merge(Log.get_config_color_theme())
	theme.merge(Log.COLORS_TERMINAL_SAFE)
	return theme

static func should_use_color(opts: Dictionary = {}) -> bool:
	if Log.get_disable_colors():
		return false
	# supports per-print color skipping
	if opts.get("disable_colors", false):
		return false
	return true

static func color_wrap(s: Variant, opts: Dictionary = {}) -> String:
	# don't rebuild the theme every time
	var colors: Dictionary = opts.get("built_color_theme", get_color_theme(opts))

	if not should_use_color(opts):
		return str(s)

	var color: String = opts.get("color")
	if not color:
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

	if color == null:
		print("Log.gd could not determine color for object: %s type: (%s)" % [str(s), typeof(s)])

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
## [code]func(obj, _opts): return {name=obj.name}[/code]
static func register_type_overwrite(key: String, handler: Callable) -> void:
	# TODO warning on key exists? support multiple handlers for same type?
	# validate the key/handler somehow?
	type_overwrites[key] = handler

## Register a dictionary of type overwrite.
##
## [br][br]
## Expects a Dictionary like [code]{obj.get_class(): func(obj, opts): return {key=obj.get_key()}}[/code].
##
## [br][br]
## It depends on [code]obj.get_class()[/code] then [code]typeof(obj)[/code] for the key.
## The handler is called with the object and an options dict (e.g. [code]func(obj, _opts): return {name=obj.name}[/code]).
static func register_type_overwrites(overwrites: Dictionary) -> void:
	type_overwrites.merge(overwrites, true)

static func clear_type_overwrites() -> void:
	type_overwrites = {}

## to_pretty ###########################################################################

## Returns the passed object as a bb-colorized string.
##
## [br][br]
## Useful for feeding directly into a RichTextLabel, but also the core
## of Log.gd's functionality.
static func to_pretty(msg: Variant, opts: Dictionary = {}) -> String:
	var newlines: bool = opts.get("newlines", false)
	var indent_level: int = opts.get("indent_level", 0)
	if not "indent_level" in opts:
		opts["indent_level"] = indent_level

	var theme: Dictionary = opts.get("built_color_theme", get_color_theme(opts))
	if not "built_color_theme" in opts:
		opts["built_color_theme"] = theme

	if not is_instance_valid(msg) and typeof(msg) == TYPE_OBJECT:
		return str("invalid instance: ", msg)

	if msg == null:
		return Log.color_wrap(msg, opts)

	if msg is Object and msg.get_class() in type_overwrites:
		# TODO support single arity (no opts) impls?
		return type_overwrites.get(msg.get_class()).call(msg, opts)
	elif typeof(msg) in type_overwrites:
		return type_overwrites.get(typeof(msg)).call(msg, opts)

	# objects
	if msg is Object and msg.has_method("to_pretty"):
		return Log.to_pretty(msg.to_pretty(), opts)
	if msg is Object and msg.has_method("data"):
		return Log.to_pretty(msg.data(), opts)
	# DEPRECATED
	if msg is Object and msg.has_method("to_printable"):
		return Log.to_pretty(msg.to_printable(), opts)

	# arrays
	if msg is Array or msg is PackedStringArray:
		if len(msg) > Log.get_max_array_size():
			pr("[DEBUG]: truncating large array. total:", len(msg))
			msg = msg.slice(0, Log.get_max_array_size() - 1)
			if newlines:
				msg.append("...")

		var tmp: String = Log.color_wrap("[ ", opts)
		var last: int = len(msg) - 1
		for i: int in range(len(msg)):
			if newlines and last > 1:
				tmp += "\n\t"
			tmp += Log.to_pretty(msg[i],
				# duplicate here to prevent indenting-per-msg
				# e.g. when printing an array of dictionaries
				opts.duplicate(true))
			if i != last:
				tmp += Log.color_wrap(", ", opts)
		tmp += Log.color_wrap(" ]", opts)
		return tmp

	# dictionary
	elif msg is Dictionary:
		var tmp: String = Log.color_wrap("{ ", opts)
		var ct: int = len(msg)
		var last: Variant
		if len(msg) > 0:
			last = msg.keys()[-1]
		for k: Variant in msg.keys():
			var val: Variant
			if k in Log.get_dictionary_skip_keys():
				val = "..."
			else:
				opts.indent_level += 1
				val = Log.to_pretty(msg[k], opts)
			if newlines and ct > 1:
				tmp += "\n\t" \
					+ range(indent_level)\
					.map(func(_i: int) -> String: return "\t")\
					.reduce(func(a: String, b: Variant) -> String: return str(a, b), "")
			var key: String = Log.color_wrap('"%s"' % k, Log.assoc(opts, "typeof", "dict_key"))
			tmp += "%s: %s" % [key, val]
			if last and str(k) != str(last):
				tmp += Log.color_wrap(", ", opts)
		tmp += Log.color_wrap(" }", opts)
		return tmp

	# strings
	elif msg is String:
		if msg == "":
			return '""'
		if "[color=" in msg and "[/color]" in msg:
			# assumes the string is already colorized
			# NOT PERFECT! could use a regex for something more robust
			return msg
		return Log.color_wrap(msg, opts)
	elif msg is StringName:
		return str(Log.color_wrap("&", opts), '"%s"' % msg)
	elif msg is NodePath:
		return str(Log.color_wrap("^", opts), '"%s"' % msg)

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
		if msg.resource_path != "":
			return str(Log.color_wrap("PackedScene:", opts), '%s' % msg.resource_path.get_file())
		elif msg.get_script() != null and msg.get_script().resource_path != "":
			return Log.color_wrap(msg.get_script().resource_path.get_file(), Log.assoc(opts, "typeof", "class_name"))
		else:
			return Log.color_wrap(msg, opts)

	# resource
	elif msg is Resource:
		if msg.get_script() != null and msg.get_script().resource_path != "":
			return Log.color_wrap(msg.get_script().resource_path.get_file(), Log.assoc(opts, "typeof", "class_name"))
		elif msg.resource_path != "":
			return str(Log.color_wrap("Resource:", opts), '%s' % msg.resource_path.get_file())
		else:
			return Log.color_wrap(msg, opts)

	# refcounted
	elif msg is RefCounted:
		if msg.get_script() != null and msg.get_script().resource_path != "":
			return Log.color_wrap(msg.get_script().resource_path.get_file(), Log.assoc(opts, "typeof", "class_name"))
		else:
			return Log.color_wrap(msg.get_class(), Log.assoc(opts, "typeof", "class_name"))

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
		setup_config()

	if not msgs is Array:
		msgs = [msgs]
	var stack: Array = opts.get("stack", [])
	var pretty: bool = opts.get("pretty", true)
	var m: String = ""
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

## public print fns ###########################################################################

static func is_not_default(v: Variant) -> bool:
	return not v is String or (v is String and v != "ZZZDEF")

## Pretty-print the passed arguments in a single line.
static func pr(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

## Pretty-print the passed arguments in a single line.
static func info(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

## Pretty-print the passed arguments in a single line.
static func log(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

## Pretty-print the passed arguments, expanding dictionaries and arrays with newlines and indentation.
static func prn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m: String = Log.to_printable(msgs, {stack=get_stack(), newlines=true})
	print_rich(m)

## Like [code]Log.prn()[/code], but also calls push_warning() with the pretty string.
static func warn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m: String = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_warning(m)

## Like [code]Log.prn()[/code], but prepends a "[TODO]" and calls push_warning() with the pretty string.
static func todo(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	msgs.push_front("[TODO]")
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m: String = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_warning(m)

## Like [code]Log.prn()[/code], but also calls push_error() with the pretty string.
static func err(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m: String = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_error(m)

## Like [code]Log.prn()[/code], but also calls push_error() with the pretty string.
static func error(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs: Array = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m: String = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_error(m)
