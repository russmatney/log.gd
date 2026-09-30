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


static var config: LogConfig = LogConfig.new()
static var logger: LogGDLogger = LogGDLogger.new()


###################
# Applying Colors #
###################

static func should_use_color(opts: Dictionary = {}) -> bool:
	return logger.should_use_color(opts)


static func get_color_using_typeof(s: Variant, opts: Dictionary) -> Variant:
	return logger.get_color_using_typeof(s, opts)


static func color_wrap(s: Variant, opts: Dictionary = {}) -> String:
	return logger.color_wrap(s, opts)


###################
# Type Overwrites #
###################

## Register a single type overwrite.
##
## [br][br]
## The key should be either obj.get_class() or typeof(var). (Note that using typeof(var) may overwrite more broadly than expected).
##
## [br][br]
## The handler is called with the object and an options dict.
## [code]func(obj): return {name=obj.name}[/code]
static func register_type_overwrite(key: String, handler: Callable) -> void:
	logger.register_type_overwrite(key, handler)


## Register a dictionary of type overwrite.
##
## [br][br]
## Expects a Dictionary like [code]{obj.get_class(): func(obj): return {key=obj.get_key()}}[/code].
##
## [br][br]
## It depends on [code]obj.get_class()[/code] then [code]typeof(obj)[/code] for the key.
## The handler is called with the object as the only argument. (e.g. [code]func(obj): return {name=obj.name}[/code]).
static func register_type_overwrites(overwrites: Dictionary) -> void:
	logger.register_type_overwrites(overwrites)


static func clear_type_overwrites() -> void:
	logger.clear_type_overwrites()


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
	return logger.to_pretty(msg, opts)


################
# to_printable #
################

static func log_prefix(stack: Array) -> String:
	return logger.log_prefix(stack)


static func to_printable(msgs: Array, opts: Dictionary = {}) -> String:
	return logger.to_printable(msgs, opts)


#############
# timestamp #
#############

static func timestamp() -> String:
	return logger.timestamp()


##########################
# Public Print Functions #
##########################

## Pretty-print the passed arguments in a single line.
static func pr(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.pr(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with a newline and indentation.
static func prn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.prn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with two newlines and indentation.
static func prnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.prnn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments, expanding dictionaries and arrays with three newlines and indentation.
static func prnnn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.prnnn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func log(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.log(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.debug(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Pretty-print the passed arguments in a single line.
static func info(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.info(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_warning() with the pretty string.
static func warn(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.warn(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but prepends a "[TODO]" and calls push_warning() with the pretty string.
static func todo(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.todo(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty string.
static func err(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.err(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## Like [code]Log.pr()[/code], but also calls push_error() with the pretty string.
static func error(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger.error(msg, msg2, msg3, msg4, msg5, msg6, msg7)


static func blank() -> void:
	logger.blank()


## Helper that will both print() and print_rich() the enriched string
static func _internal_debug(msg: Variant, msg2: Variant = "ZZZDEF", msg3: Variant = "ZZZDEF", msg4: Variant = "ZZZDEF", msg5: Variant = "ZZZDEF", msg6: Variant = "ZZZDEF", msg7: Variant = "ZZZDEF") -> void:
	logger._internal_debug(msg, msg2, msg3, msg4, msg5, msg6, msg7)


## DEPRECATED
static func merge_theme_overwrites(_opts = {}) -> void:
	pass

## DEPRECATED
static func clear_theme_overwrites() -> void:
	pass
