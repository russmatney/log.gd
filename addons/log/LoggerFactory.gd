## LoggerFactory - Factory for managing named PrettyLogger instances
##
## Provides convenient methods for creating, retrieving, and managing PrettyLogger instances.
## Supports both resource-based loggers (created via inspector) and programmatically created loggers.
##
## Example:
## [code]
## # Get or create a logger with custom config
## var ui_logger = LoggerFactory.get_logger("UI", {
##     "log_level": Log.Levels.DEBUG,
##     "show_timestamps": true
## })
##
## # Load a logger from a resource file
## var network_logger = LoggerFactory.load_logger("res://loggers/network_logger.tres")
##
## # Enable/disable all loggers at once
## LoggerFactory.disable_all()
## LoggerFactory.enable_all()
## [/code]

@tool
extends RefCounted
class_name LoggerFactory

static var _loggers: Dictionary = {}

## Get or create a named logger with optional configuration
## If the logger already exists, it returns the existing instance
## If config is provided, it will be applied to the logger
static func get_logger(name: String, config: Dictionary = {}) -> PrettyLogger:
	if name not in _loggers:
		_loggers[name] = PrettyLogger.new()
		_loggers[name].logger_name = name

	var logger: PrettyLogger = _loggers[name]

	# Apply configuration if provided
	if not config.is_empty():
		configure_logger(logger, config)

	return logger

## Create a new logger with the given name and configuration
## This will replace any existing logger with the same name
static func create_logger(name: String, config: Dictionary = {}) -> PrettyLogger:
	var logger = PrettyLogger.new()
	logger.logger_name = name

	if not config.is_empty():
		configure_logger(logger, config)

	_loggers[name] = logger
	return logger

## Load a logger from a resource file
## The logger will be registered using its logger_name property or the filename if no name is set
static func load_logger(resource_path: String) -> PrettyLogger:
	var logger = load(resource_path) as PrettyLogger
	if logger == null:
		push_error("Failed to load PrettyLogger from: " + resource_path)
		return null

	# Use the logger's name property, or fall back to filename
	var name = logger.logger_name
	if name == "" or name == null:
		name = resource_path.get_file().get_basename()
		logger.logger_name = name

	_loggers[name] = logger
	return logger

## Register an existing PrettyLogger instance
static func register_logger(logger: PrettyLogger) -> void:
	if logger.logger_name == "" or logger.logger_name == null:
		push_error("Cannot register logger without a name")
		return

	_loggers[logger.logger_name] = logger

## Check if a logger with the given name exists
static func has_logger(name: String) -> bool:
	return name in _loggers

## Get a logger by name, returns null if it doesn't exist
static func find_logger(name: String) -> PrettyLogger:
	return _loggers.get(name, null)

## Remove a logger by name
static func remove_logger(name: String) -> bool:
	if name in _loggers:
		_loggers.erase(name)
		return true
	return false

## Get all registered logger names
static func get_logger_names() -> Array[String]:
	var names: Array[String] = []
	for name in _loggers.keys():
		names.append(name)
	return names

## Get all registered loggers
static func get_all_loggers() -> Array[PrettyLogger]:
	var loggers: Array[PrettyLogger] = []
	for logger in _loggers.values():
		loggers.append(logger)
	return loggers

## Clear all registered loggers
static func clear_all() -> void:
	_loggers.clear()

## Bulk Operations

## Enable all registered loggers
static func enable_all() -> void:
	for logger: PrettyLogger in _loggers.values():
		logger.enable_logger()

## Disable all registered loggers
static func disable_all() -> void:
	for logger: PrettyLogger in _loggers.values():
		logger.disable_logger()

## Set log level for all registered loggers
static func set_all_log_levels(level: Log.Levels) -> void:
	for logger: PrettyLogger in _loggers.values():
		logger.set_log_level(level)

## Enable timestamps for all registered loggers
static func enable_all_timestamps() -> void:
	for logger: PrettyLogger in _loggers.values():
		logger.set_timestamps_enabled(true)

## Disable timestamps for all registered loggers
static func disable_all_timestamps() -> void:
	for logger: PrettyLogger in _loggers.values():
		logger.set_timestamps_enabled(false)

## Configuration Helpers

## Apply configuration dictionary to a logger
static func configure_logger(logger: PrettyLogger, config: Dictionary) -> void:
	# Map configuration keys to logger properties
	if "log_level" in config:
		logger.log_level = config["log_level"]
	if "enabled" in config:
		logger.enabled = config["enabled"]
	if "warn_todo" in config:
		logger.warn_todo = config["warn_todo"]
	if "disable_colors" in config:
		logger.disable_colors = config["disable_colors"]
	if "force_termsafe_colors" in config:
		logger.force_termsafe_colors = config["force_termsafe_colors"]
	if "use_newlines" in config:
		logger.use_newlines = config["use_newlines"]
	if "newline_max_depth" in config:
		logger.newline_max_depth = config["newline_max_depth"]
	if "max_array_size" in config:
		logger.max_array_size = config["max_array_size"]
	if "dictionary_skip_keys" in config:
		logger.dictionary_skip_keys = config["dictionary_skip_keys"]
	if "show_timestamps" in config:
		logger.show_timestamps = config["show_timestamps"]
	if "timestamp_type" in config:
		logger.timestamp_type = config["timestamp_type"]
	if "human_readable_timestamp_format" in config:
		logger.human_readable_timestamp_format = config["human_readable_timestamp_format"]
	if "color_theme_resource" in config:
		logger.color_theme_resource = config["color_theme_resource"]

	# Mark config as dirty so it gets rebuilt
	logger._mark_config_dirty()

## Builder Pattern Support

## Create a LoggerBuilder for fluent configuration
static func builder(name: String) -> LoggerBuilder:
	return LoggerBuilder.new(name)

## LoggerBuilder - Fluent interface for creating configured loggers
class LoggerBuilder extends RefCounted:
	var _name: String
	var _config: Dictionary = {}

	func _init(logger_name: String):
		_name = logger_name

	func with_level(level: Log.Levels) -> LoggerBuilder:
		_config["log_level"] = level
		return self

	func with_timestamps(enable: bool = true) -> LoggerBuilder:
		_config["show_timestamps"] = enable
		return self

	func with_timestamp_type(type: Log.TimestampTypes) -> LoggerBuilder:
		_config["timestamp_type"] = type
		return self

	func with_colors(enable: bool = true) -> LoggerBuilder:
		_config["disable_colors"] = not enable
		return self

	func with_termsafe_colors(enable: bool = true) -> LoggerBuilder:
		_config["force_termsafe_colors"] = enable
		return self

	func with_newlines(enable: bool = true, max_depth: int = -1) -> LoggerBuilder:
		_config["use_newlines"] = enable
		if max_depth >= 0:
			_config["newline_max_depth"] = max_depth
		return self

	func with_theme(theme: LogColorTheme) -> LoggerBuilder:
		_config["color_theme_resource"] = theme
		return self

	func with_array_limit(limit: int) -> LoggerBuilder:
		_config["max_array_size"] = limit
		return self

	func enabled(enable: bool = true) -> LoggerBuilder:
		_config["enabled"] = enable
		return self

	func build() -> PrettyLogger:
		return LoggerFactory.create_logger(_name, _config)
