@tool
extends Object
class_name Log

## helpers ####################################

static func assoc(opts: Dictionary, key: String, val):
	var _opts = opts.duplicate(true)
	_opts[key] = val
	return _opts

## config ####################################

static var config = {
	max_array_size=20,
	dictionary_skip_keys=[
		"layer_0/tile_data", # skip huge tilemap arrays
		],
	color_scheme={},
	disable_colors=false,
	}

static func get_max_array_size():
	return Log.config.get("max_array_size", 20)

static func get_dictionary_skip_keys():
	return Log.config.get("dictionary_skip_keys", [])

static func get_disable_colors():
	return Log.config.get("disable_colors", false)

static func disable_colors():
	Log.config["disable_colors"] = true

static func enable_colors():
	Log.config["disable_colors"] = false

static func set_color_scheme(scheme):
	Log.config["color_scheme"] = scheme

static func get_config_color_scheme():
	return Log.config.get("color_scheme", {})

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

static var COLORS_TERMINAL_SAFE = {
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

static var COLORS_PRETTY_V1 = {
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

## set color scheme ####################################

static func set_colors_termsafe():
	set_color_scheme(Log.COLORS_TERMINAL_SAFE)

static func set_colors_pretty():
	set_color_scheme(Log.COLORS_PRETTY_V1)

static func color_scheme(opts={}):
	var scheme = opts.get("color_scheme", {})
	# fill in any missing vals with the set scheme, then the term-safe fallbacks
	scheme.merge(Log.get_config_color_scheme())
	scheme.merge(Log.COLORS_TERMINAL_SAFE)
	return scheme

static func should_use_color(opts={}):
	if Log.get_disable_colors():
		return false
	# supports per-print color skipping
	if opts.get("disable_colors", false):
		return false
	return true

static func color_wrap(s, opts={}):
	# don't rebuild the color scheme every time
	var colors = opts.get("built_color_scheme", color_scheme(opts))

	if not should_use_color(opts):
		return str(s)

	var color = opts.get("color")
	if not color:
		var s_type = opts.get("typeof", typeof(s))
		if s_type is String:
			# type overwrites
			color = colors.get(s_type)
		elif s_type is int and s_type == TYPE_STRING:
			# specific strings/punctuation
			var s_trimmed = s.strip_edges()
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

static var log_overwrites = {
	"Vector2": func(msg, opts):
		return '%s%s%s%s%s' % [
			Log.color_wrap("(", opts),
			Log.color_wrap(msg.x, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(",", opts),
			Log.color_wrap(msg.y, Log.assoc(opts, "typeof", "vector_value")),
			Log.color_wrap(")", opts),
		]
		}

static func register_overwrite(key, handler):
	# TODO warning on key exists?
	# support multiple handlers?
	# return success/fail?
	# validate the key/handler somehow?
	log_overwrites[key] = handler

## to_pretty ###########################################################################

# returns the passed object as a decorated string
static func to_pretty(msg, opts={}):
	var newlines = opts.get("newlines", false)
	var indent_level = opts.get("indent_level", 0)
	if not "indent_level" in opts:
		opts["indent_level"] = indent_level

	var color_scheme = opts.get("built_color_scheme", color_scheme(opts))
	if not "built_color_scheme" in opts:
		opts["built_color_scheme"] = color_scheme

	if not is_instance_valid(msg) and typeof(msg) == TYPE_OBJECT:
		return str("invalid instance: ", msg)

	if msg == null:
		return Log.color_wrap(msg, opts)

	if msg is Object and msg.get_class() in log_overwrites:
		return log_overwrites.get(msg.get_class()).call(msg, opts)
	elif typeof(msg) in log_overwrites:
		return log_overwrites.get(typeof(msg)).call(msg, opts)

	# objects
	if msg is Object and msg.has_method("to_pretty"):
		return Log.to_pretty(msg.to_pretty(), opts)
	if msg is Object and msg.has_method("data"):
		return Log.to_pretty(msg.data(), opts)
	if msg is Object and msg.has_method("to_printable"):
		return Log.to_pretty(msg.to_printable(), opts)

	# arrays
	if msg is Array or msg is PackedStringArray:
		if len(msg) > Log.get_max_array_size():
			pr("[DEBUG]: truncating large array. total:", len(msg))
			msg = msg.slice(0, Log.get_max_array_size() - 1)
			if newlines:
				msg.append("...")

		var tmp = Log.color_wrap("[ ", opts)
		var last = len(msg) - 1
		for i in range(len(msg)):
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
		var tmp = Log.color_wrap("{ ", opts)
		var ct = len(msg)
		var last
		if len(msg) > 0:
			last = msg.keys()[-1]
		for k in msg.keys():
			var val
			if k in Log.get_dictionary_skip_keys():
				val = "..."
			else:
				opts.indent_level += 1
				val = Log.to_pretty(msg[k], opts)
			if newlines and ct > 1:
				tmp += "\n\t" \
					+ range(indent_level)\
					.map(func(_i): return "\t")\
						.reduce(func(a, b): return str(a, b), "")
			var key = Log.color_wrap('"%s"' % k, Log.assoc(opts, "typeof", "dict_key"))
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
		return log_overwrites.get("Vector2").call(msg, opts)

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

static func log_prefix(stack):
	if len(stack) > 1:
		var call_site = stack[1]
		var basename = call_site["source"].get_file().get_basename()
		var line_num = str(call_site.get("line", 0))
		if call_site["source"].match("*/test/*"):
			return "{" + basename + ":" + line_num + "}: "
		elif call_site["source"].match("*/addons/*"):
			return "<" + basename + ":" + line_num + ">: "
		else:
			return "[" + basename + ":" + line_num + "]: "

static func to_printable(msgs, opts={}):
	var stack = opts.get("stack", [])
	var pretty = opts.get("pretty", true)
	var newlines = opts.get("newlines", false)
	var m = ""
	if len(stack) > 0:
		var prefix = Log.log_prefix(stack)
		var prefix_type
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
	for msg in msgs:
		# add a space between msgs
		if pretty:
			m += "%s " % Log.to_pretty(msg, opts)
		else:
			m += "%s " % str(msg)
	return m.trim_suffix(" ")

## public print fns ###########################################################################

static func is_not_default(v):
	return not v is String or (v is String and v != "ZZZDEF")

static func pr(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

static func info(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

static func log(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

static func prn(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m = Log.to_printable(msgs, {stack=get_stack(), newlines=true})
	print_rich(m)

static func warn(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs = msgs.duplicate()
	rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_warning(m)

static func err(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_error(m)

static func error(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_error(m)
