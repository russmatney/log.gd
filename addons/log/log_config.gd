class_name LogConfig
extends Object
## Config object for Log.gd


const KEY_PREFIX: String = "log_gd/config"

# TODO drop this key
const KEY_COLOR_THEME_DICT: String = "log_color_theme_dict"
const KEY_COLOR_THEME: String = "log_color_theme"
const KEY_COLOR_THEME_RESOURCE_PATH: String = "%s/color_resource_path" % KEY_PREFIX
const KEY_DISABLE_COLORS: String = "%s/disable_colors" % KEY_PREFIX
const KEY_FORCE_TERMSAFE_COLORS: String = "%s/force_termsafe_colors" % KEY_PREFIX
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
const KEY_SHOW_PROCESS_UNIQUE_ID: String = "%s/show_process_unique_id" % KEY_PREFIX

const CONFIG_DEFAULTS: Dictionary[String, Variant] = {
	KEY_COLOR_THEME_RESOURCE_PATH: "res://addons/log/color_theme_dark.tres",
	KEY_DISABLE_COLORS: false,
	KEY_FORCE_TERMSAFE_COLORS: false,
	KEY_MAX_ARRAY_SIZE: 20,
	KEY_SKIP_KEYS: ["layer_0/tile_data"],
	KEY_USE_NEWLINES: false,
	KEY_NEWLINE_MAX_DEPTH: -1,
	KEY_LOG_LEVEL: Log.Levels.INFO,
	KEY_WARN_TODO: true,
	KEY_SHOW_LOG_LEVEL_SELECTOR: false,
	KEY_SHOW_TIMESTAMPS: false,
	KEY_TIMESTAMP_TYPE: Log.TimestampTypes.HUMAN_12HR,
	KEY_HUMAN_READABLE_TIMESTAMP_FORMAT: "{hour}:{minute}:{second}",
	KEY_SHOW_PROCESS_UNIQUE_ID: false,
}


var is_config_setup: bool = false
var values: Dictionary[String, Variant] = {}
var warned_about_termsafe_fallback: bool = false


static func initialize_setting(
	key: String,
	default_value: Variant,
	type: int,
	hint: int = PROPERTY_HINT_NONE,
	hint_string: String = "",
) -> void:
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set(key, default_value)
	ProjectSettings.set_initial_value(key, default_value)
	ProjectSettings.add_property_info({
		"name": key,
		"type": type,
		"hint": hint,
		"hint_string": hint_string,
	})


static func rebuild_config(config: LogConfig, opts: Dictionary = {}) -> void:
	for key: String in CONFIG_DEFAULTS.keys():
		# Keep config set in code before to_printable() is called for the first
		# time
		var val: Variant = config.values.get(
			key, ProjectSettings.get_setting(key, CONFIG_DEFAULTS[key])
		)
		config.values[key] = val

		# hardcoding a resource-load b/c it seems like custom-resources can't be
		# loaded by the project settings
		# https://github.com/godotengine/godot/issues/96219
		if val != null and key == KEY_COLOR_THEME_RESOURCE_PATH:
			config.values[KEY_COLOR_THEME] = load(val)
			config.values[KEY_COLOR_THEME_DICT] = (
				config.values[KEY_COLOR_THEME].to_color_dict()
			)

	if (config.get_force_termsafe_colors()):
		print("NOTE: Forcing TERM_SAFE colors from config")
		config.set_colors_termsafe()

	config.is_config_setup = true


static func setup_settings(opts: Dictionary = {}) -> void:
	initialize_setting(KEY_COLOR_THEME_RESOURCE_PATH, CONFIG_DEFAULTS[KEY_COLOR_THEME_RESOURCE_PATH], TYPE_STRING, PROPERTY_HINT_FILE)
	initialize_setting(KEY_DISABLE_COLORS, CONFIG_DEFAULTS[KEY_DISABLE_COLORS], TYPE_BOOL)
	initialize_setting(KEY_FORCE_TERMSAFE_COLORS, CONFIG_DEFAULTS[KEY_FORCE_TERMSAFE_COLORS], TYPE_BOOL)
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
	initialize_setting(KEY_SHOW_PROCESS_UNIQUE_ID, CONFIG_DEFAULTS[KEY_SHOW_PROCESS_UNIQUE_ID], TYPE_BOOL)


##########
# Arrays #
##########

func get_max_array_size() -> int:
	return values.get(LogConfig.KEY_MAX_ARRAY_SIZE, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_MAX_ARRAY_SIZE])


##########
# Colors #
##########

## Disable color-wrapping output.
##
## [br][br]
## Useful to declutter the output if the environment does not support colors.
## Note that some environments support only a subset of colors - you may prefer
## [code]set_colors_termsafe()[/code].
func disable_colors() -> void:
	values[KEY_DISABLE_COLORS] = true


## Re-enable color-wrapping output.
func enable_colors() -> void:
	values[KEY_DISABLE_COLORS] = false


func get_config_color_theme() -> LogColorTheme:
	var color_theme = values.get(LogConfig.KEY_COLOR_THEME)
	# TODO better warnings, fallbacks
	return color_theme


# TODO consider termsafe LogColorThemes
func get_config_color_theme_dict() -> Dictionary:
	var color_theme = values.get(LogConfig.KEY_COLOR_THEME)
	var color_dict = values.get(LogConfig.KEY_COLOR_THEME_DICT)
	if color_dict != null:
		return color_dict
	if not warned_about_termsafe_fallback:
		print("Falling back to TERM_SAFE colors")
		warned_about_termsafe_fallback = true
	return LogColorTheme.COLORS_TERM_SAFE


func get_disable_colors() -> bool:
	return values.get(LogConfig.KEY_DISABLE_COLORS, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_DISABLE_COLORS])


func get_force_termsafe_colors() -> bool:
	return values.get(LogConfig.KEY_FORCE_TERMSAFE_COLORS, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_FORCE_TERMSAFE_COLORS])


## Use prettier colors - i.e. whatever LogColorTheme is configured.
func set_colors_pretty() -> void:
	var theme_path: Variant = values.get(KEY_COLOR_THEME_RESOURCE_PATH)
	# TODO proper string, file, resource load check here
	if theme_path != null:
		values[KEY_COLOR_THEME] = load(theme_path)
		values[KEY_COLOR_THEME_DICT] = values[KEY_COLOR_THEME].to_color_dict()
	else:
		print("WARNING no color theme resource path to load!")


## Use the terminal safe color scheme, which should support colors in most tty-like environments.
func set_colors_termsafe() -> void:
	values[KEY_COLOR_THEME_DICT] = LogColorTheme.COLORS_TERM_SAFE


################
# Dictionaries #
################

func get_dictionary_skip_keys() -> Array:
	return values.get(LogConfig.KEY_SKIP_KEYS, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_SKIP_KEYS])


#############
# Log Level #
#############

func get_log_level() -> int:
	if not is_config_setup:
		rebuild_config(self)
	return values.get(LogConfig.KEY_LOG_LEVEL, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_LOG_LEVEL])


## Set the minimum level of logs that get printed
func set_log_level(new_log_level: int) -> void:
	values[KEY_LOG_LEVEL] = new_log_level


############
# Newlines #
############

## Disable newlines in pretty-print output.
##
## [br][br]
## Useful if you want your log output on a single line, typically for use with
## log aggregation tools.
func disable_newlines() -> void:
	values[KEY_USE_NEWLINES] = false


## Re-enable newlines in pretty-print output.
func enable_newlines() -> void:
	values[KEY_USE_NEWLINES] = true


func get_use_newlines() -> bool:
	return values.get(LogConfig.KEY_USE_NEWLINES, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_USE_NEWLINES])


func get_newline_max_depth() -> int:
	return values.get(LogConfig.KEY_NEWLINE_MAX_DEPTH, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_NEWLINE_MAX_DEPTH])


## Set the maximum depth of an object that will get its own newline.
##
## [br][br]
## Useful if you have deeply nested objects where you're primarly interested
## in easily parsing the information near the root of the object.
func set_newline_max_depth(new_depth: int) -> void:
	values[KEY_NEWLINE_MAX_DEPTH] = new_depth


## Resets the maximum object depth for newlines to the default.
func reset_newline_max_depth() -> void:
	values[KEY_USE_NEWLINES] = CONFIG_DEFAULTS[KEY_NEWLINE_MAX_DEPTH]


##############
# Process ID #
##############

## Show process ID
func get_show_process_unique_id() -> bool:
	return values.get(LogConfig.KEY_SHOW_PROCESS_UNIQUE_ID, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_SHOW_PROCESS_UNIQUE_ID])


## Don't SHOW_PROCESS_UNIQUE_ID in log line
func hide_process_unique_id() -> void:
	values[KEY_SHOW_PROCESS_UNIQUE_ID] = false


## Show SHOW_PROCESS_UNIQUE_ID in log lines
func show_process_unique_id() -> void:
	values[KEY_SHOW_PROCESS_UNIQUE_ID] = true


##############
# Timestamps #
##############

func get_show_timestamps() -> bool:
	return values.get(LogConfig.KEY_SHOW_TIMESTAMPS, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_SHOW_TIMESTAMPS])


func get_timestamp_type() -> Log.TimestampTypes:
	return values.get(LogConfig.KEY_TIMESTAMP_TYPE, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_TIMESTAMP_TYPE])


func get_timestamp_format() -> String:
	return values.get(LogConfig.KEY_HUMAN_READABLE_TIMESTAMP_FORMAT, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_HUMAN_READABLE_TIMESTAMP_FORMAT])


## Don't timestamps in log lines
func hide_timestamps() -> void:
	values[KEY_SHOW_TIMESTAMPS] = false


## Show timestamps in log lines
func show_timestamps() -> void:
	values[KEY_SHOW_TIMESTAMPS] = true


## Use the given timestamp type
func use_timestamp_type(timestamp_type: Log.TimestampTypes) -> void:
	values[KEY_TIMESTAMP_TYPE] = timestamp_type


## Use the given timestamp format
func use_timestamp_format(timestamp_format: String) -> void:
	values[KEY_HUMAN_READABLE_TIMESTAMP_FORMAT] = timestamp_format


################
# Warn on TODO #
################

func get_warn_todo() -> int:
	return values.get(LogConfig.KEY_WARN_TODO, LogConfig.CONFIG_DEFAULTS[LogConfig.KEY_WARN_TODO])


## Disable warning on Log.todo().
func disable_warn_todo() -> void:
	values[KEY_WARN_TODO] = false


## Re-enable warning on Log.todo().
func enable_warn_todo() -> void:
	values[KEY_WARN_TODO] = true
