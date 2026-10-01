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


static var core: LogCore = LogCore.new(LOGGER_NAME)


###################
# Applying Colors #
###################

static func should_use_color(opts: Dictionary = {}) -> bool:
	return core.should_use_color(opts)


static func get_color_using_typeof(s: Variant, opts: Dictionary) -> Variant:
	return core.get_color_using_typeof(s, opts)


static func get_config_color_theme() -> LogColorTheme:
	return core.config.get_config_color_theme()


static func get_config_color_theme_dict() -> Dictionary:
	return core.config.get_config_color_theme_dict()


static func get_disable_colors() -> bool:
	return core.config.get_disable_colors()


static func get_force_termsafe_colors() -> bool:
	return core.config.get_force_termsafe_colors()


static func color_wrap(s: Variant, opts: Dictionary = {}) -> String:
	return core.color_wrap(s, opts)


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
	core.config.disable_colors()


## Re-enable color-wrapping output.
static func enable_colors() -> void:
	core.config.enable_colors()


## Use prettier colors - i.e. whatever LogColorTheme is configured.
static func set_colors_pretty() -> void:
	core.config.set_colors_pretty()


## Use the terminal safe color scheme, which should support colors in most tty-like environments.
static func set_colors_termsafe() -> void:
	core.config.set_colors_termsafe()


##########
# Config #
##########

static func rebuild_config(opts: Dictionary = {}) -> void:
	core.config.rebuild_config(core.config, opts)


static func setup_settings(opts: Dictionary = {}) -> void:
	core.config.setup_settings(opts)


#############
# Log Level #
#############

static func get_log_level() -> int:
	return core.config.get_log_level()


## Set the minimum level of logs that get printed
static func set_log_level(new_log_level: int) -> void:
	core.config.set_log_level(new_log_level)


############
# Newlines #
############

## Disable newlines in pretty-print output.
##
## [br][br]
## Useful if you want your log output on a single line, typically for use with
## log aggregation tools.
static func disable_newlines() -> void:
	core.config.disable_newlines()


## Re-enable newlines in pretty-print output.
static func enable_newlines() -> void:
	core.config.enable_newlines()


static func get_use_newlines() -> bool:
	return core.config.get_use_newlines()


static func get_newline_max_depth() -> int:
	return core.config.get_newline_max_depth()


## Resets the maximum object depth for newlines to the default.
static func reset_newline_max_depth() -> void:
	core.config.reset_newline_max_depth()


## Set the maximum depth of an object that will get its own newline.
##
## [br][br]
## Useful if you have deeply nested objects where you're primarly interested
## in easily parsing the information near the root of the object.
static func set_newline_max_depth(new_depth: int) -> void:
	core.config.set_newline_max_depth(new_depth)


##############
# Timestamps #
##############

static func get_show_timestamps() -> bool:
	return core.config.get_show_timestamps()


static func get_timestamp_type() -> Log.TimestampTypes:
	return core.config.get_timestamp_type()


static func get_timestamp_format() -> String:
	return core.config.get_timestamp_format()


## Don't timestamps in log lines
static func hide_timestamps() -> void:
	core.config.hide_timestamps()


## Show timestamps in log lines
static func show_timestamps() -> void:
	core.config.show_timestamps()


## Use the given timestamp type
static func use_timestamp_type(timestamp_type: Log.TimestampTypes) -> void:
	core.config.use_timestamp_type(timestamp_type)


## Use the given timestamp format
static func use_timestamp_format(timestamp_format: String) -> void:
	core.config.use_timestamp_format(timestamp_format)


###################
# Type Overwrites #
###################

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
	core.register_type_overwrite(key, handler)


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
	core.register_type_overwrites(overwrites)


static func clear_type_overwrites() -> void:
	core.clear_type_overwrites()


################
# Warn on TODO #
################


## Disable warning on Log.todo().
static func disable_warn_todo() -> void:
	core.config.disable_warn_todo()


## Enable warning on Log.todo().
static func enable_warn_todo() -> void:
	core.config.enable_warn_todo()


static func get_warn_todo() -> int:
	return core.config.get_warn_todo()


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
	return core.to_pretty(msg, opts)


################
# to_printable #
################

static func log_prefix(stack: Array) -> String:
	return core.log_prefix(stack)


static func to_printable(msgs: Array, opts: Dictionary = {}) -> String:
	return core.to_printable(msgs, opts)


#############
# timestamp #
#############

static func timestamp() -> String:
	return core.timestamp()


##########################
# Public Print Functions #
##########################

## Pretty-print the passed arguments in a single line.
static func pr(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.pr(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with a
## newline and indentation.
static func prn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.prn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with two
## newlines and indentation.
static func prnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.prnn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with
## three newlines and indentation.
static func prnnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.prnnn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func log(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.log(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.debug(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func info(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.info(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_warning() with the pretty
## string.
static func warn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.warn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but prepends a "[TODO]" and calls push_warning()
## with the pretty string.
static func todo(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.todo(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty
## string.
static func err(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.err(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty
## string.
static func error(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core.error(msg, msg2, msg3, msg4, msg5, msg6, msg7)


static func blank() -> void:
	core.blank()


## Helper that will both print() and print_rich() the enriched string
static func _internal_debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	core._internal_debug(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## DEPRECATED
static func merge_theme_overwrites(_opts = {}) -> void:
	pass

## DEPRECATED
static func clear_theme_overwrites() -> void:
	pass
