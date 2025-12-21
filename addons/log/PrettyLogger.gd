## PrettyLogger - Named logger resource with custom configuration
##
## A Custom Resource that provides the same API as Log.gd but with instance-based configuration.
## Each logger can have its own color theme, log level, and other settings that can be
## configured in the Godot Inspector.
##
## Example:
## [code]
## # Create via inspector or code
## var ui_logger = PrettyLogger.new()
## ui_logger.logger_name = "UI"
## ui_logger.log_level = Log.Levels.DEBUG
## ui_logger.show_timestamps = true
##
## ui_logger.debug("Button clicked")
## [/code]

@tool
extends Resource
class_name PrettyLogger

## Configuration Properties

@export var logger_name: String = ""
@export var enabled: bool = true

@export_group("Logging Levels")
@export var log_level: Log.Levels = Log.Levels.INFO
@export var warn_todo: bool = true

@export_group("Visual Options")
@export var color_theme_resource: LogColorTheme
@export var disable_colors: bool = false
@export var force_termsafe_colors: bool = false

@export_group("Formatting")
@export var use_newlines: bool = false
@export var newline_max_depth: int = -1
@export var max_array_size: int = 20
@export var dictionary_skip_keys: PackedStringArray = ["layer_0/tile_data"]

@export_group("Timestamps")
@export var show_timestamps: bool = false
@export var timestamp_type: Log.TimestampTypes = Log.TimestampTypes.HUMAN_12HR
@export var human_readable_timestamp_format: String = "{hour}:{minute}:{second}"

## Internal state
var _config: Dictionary
var _config_dirty: bool = true

func _init():
	# Set default logger name based on resource path if available
	if resource_path != "":
		logger_name = resource_path.get_file().get_basename()

## Get the current effective configuration dictionary
func get_config() -> Dictionary:
	if _config_dirty:
		_rebuild_config()
	return _config.duplicate(true)

func _rebuild_config():
	# Start with global defaults
	_config = Log.CONFIG_DEFAULTS.duplicate(true)

	# Merge with current global config
	_config.merge(Log.config, true)

	# Apply logger-specific overrides
	_config[Log.KEY_LOG_LEVEL] = log_level
	_config[Log.KEY_WARN_TODO] = warn_todo
	_config[Log.KEY_DISABLE_COLORS] = disable_colors
	_config[Log.KEY_FORCE_TERMSAFE_COLORS] = force_termsafe_colors
	_config[Log.KEY_USE_NEWLINES] = use_newlines
	_config[Log.KEY_NEWLINE_MAX_DEPTH] = newline_max_depth
	_config[Log.KEY_MAX_ARRAY_SIZE] = max_array_size
	_config[Log.KEY_SKIP_KEYS] = dictionary_skip_keys
	_config[Log.KEY_SHOW_TIMESTAMPS] = show_timestamps
	_config[Log.KEY_TIMESTAMP_TYPE] = timestamp_type
	_config[Log.KEY_HUMAN_READABLE_TIMESTAMP_FORMAT] = human_readable_timestamp_format

	# Handle color theme
	if color_theme_resource != null:
		_config[Log.KEY_COLOR_THEME] = color_theme_resource
		_config[Log.KEY_COLOR_THEME_DICT] = color_theme_resource.to_color_dict()
		_config[Log.KEY_COLOR_THEME_RESOURCE_PATH] = color_theme_resource.resource_path

	_config_dirty = false

## Mark config as needing rebuild
func _mark_config_dirty():
	_config_dirty = true

## Enable/Disable Methods

## Enable this logger - all log calls will be processed
func enable_logger() -> void:
	enabled = true

## Disable this logger - all log calls will be ignored
func disable_logger() -> void:
	enabled = false

## Check if this logger is enabled
func is_enabled() -> bool:
	return enabled

## Configuration Methods

## Set the log level for this logger
func set_log_level(level: Log.Levels) -> void:
	log_level = level
	_mark_config_dirty()

## Set the color theme for this logger
func set_color_theme(theme: LogColorTheme) -> void:
	color_theme_resource = theme
	_mark_config_dirty()

## Enable/disable colors for this logger
func set_colors_enabled(enable_colors: bool) -> void:
	disable_colors = not enable_colors
	_mark_config_dirty()

## Enable/disable timestamps for this logger
func set_timestamps_enabled(enable_timestamps: bool) -> void:
	show_timestamps = enable_timestamps
	_mark_config_dirty()

## Core Logging Logic

func _should_log(level: Log.Levels) -> bool:
	if not enabled:
		return false
	return level >= log_level

func _log_with_level(level: Log.Levels, level_prefix: String, msgs: Array, use_push_warning: bool = false, use_push_error: bool = false) -> void:
	if not _should_log(level):
		return

	var stack = get_stack()
	stack.pop_front()
	var opts = {
		stack = stack,
		logger_name = logger_name,
		config = get_config()
	}

	# Add level prefix to messages
	var prefixed_msgs = msgs.duplicate()
	if level_prefix != "":
		prefixed_msgs.push_front(level_prefix)

	var m = Log.to_printable(prefixed_msgs, opts)
	print_rich(m)

	# Handle warnings and errors
	if use_push_warning or use_push_error:
		var plain_opts = opts.duplicate()
		plain_opts["disable_colors"] = true
		var plain_m = Log.to_printable(msgs, plain_opts)
		if use_push_warning:
			push_warning(plain_m)
		if use_push_error:
			push_error(plain_m)

## Pretty-printing Methods

## Pretty-print the passed arguments in a single line.
func pr(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if not enabled:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var opts = {stack = get_stack(), logger_name = logger_name, config = get_config()}
	var m = Log.to_printable(msgs, opts)
	print_rich(m)

## Pretty-print the passed arguments, expanding dictionaries and arrays with a newline and indentation.
func prn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if not enabled:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var opts = {stack = get_stack(), logger_name = logger_name, config = get_config(), newlines = true, newline_max_depth = 1}
	var m = Log.to_printable(msgs, opts)
	print_rich(m)

## Pretty-print the passed arguments, expanding dictionaries and arrays with two newlines and indentation.
func prnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if not enabled:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var opts = {stack = get_stack(), logger_name = logger_name, config = get_config(), newlines = true, newline_max_depth = 2}
	var m = Log.to_printable(msgs, opts)
	print_rich(m)

## Pretty-print the passed arguments, expanding dictionaries and arrays with three newlines and indentation.
func prnnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	if not enabled:
		return
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var opts = {stack = get_stack(), logger_name = logger_name, config = get_config(), newlines = true, newline_max_depth = 3}
	var m = Log.to_printable(msgs, opts)
	print_rich(m)

## Level-based Logging Methods

## Pretty-print debug level messages
func debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	_log_with_level(Log.Levels.DEBUG, "[DEBUG]", msgs)

## Pretty-print info level messages
func info(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	_log_with_level(Log.Levels.INFO, "[INFO]", msgs)

## Pretty-print warning messages and call push_warning()
func warn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	_log_with_level(Log.Levels.WARN, "[color=yellow][WARN][/color]", msgs, true)

## Pretty-print error messages and call push_error()
func error(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	_log_with_level(Log.Levels.ERROR, "[color=red][ERR][/color]", msgs, false, true)

## Alias for error()
func err(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	error(msg, msg2, msg3, msg4, msg5, msg6, msg7)

## Pretty-print TODO messages
func todo(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	var required_level = Log.Levels.WARN if warn_todo else Log.Levels.INFO
	if not _should_log(required_level):
		return

	var msgs: Array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	msgs.push_front("[TODO]")

	var prefix = "[color=yellow][WARN][/color]" if warn_todo else ""
	_log_with_level(required_level, prefix, msgs, warn_todo)

## Utility Methods

## Print a blank line
func blank() -> void:
	if enabled:
		print()

## Get pretty-formatted string without printing
func to_pretty(msg: Variant, opts: Dictionary = {}) -> String:
	var merged_opts = opts.duplicate(true)
	merged_opts["logger_name"] = logger_name
	merged_opts["config"] = get_config()
	return Log.to_pretty(msg, merged_opts)

## Get printable string for multiple messages
func to_printable(msgs: Array, opts: Dictionary = {}) -> String:
	var merged_opts = opts.duplicate(true)
	merged_opts["logger_name"] = logger_name
	merged_opts["config"] = get_config()
	return Log.to_printable(msgs, merged_opts)
