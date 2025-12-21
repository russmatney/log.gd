extends GdUnitTestSuite

func before_test() -> void:
	Log.config = {}
	Log.is_config_setup = false
	LoggerFactory.clear_all()

func test_create_pretty_logger() -> void:
	var logger: PrettyLogger = PrettyLogger.new()
	logger.logger_name = "TestLogger"

	assert_that(logger.logger_name).is_equal("TestLogger")
	assert_bool(logger.enabled).is_true()

func test_logger_factory_get_logger() -> void:
	var logger: PrettyLogger = LoggerFactory.get_logger("UI")

	assert_that(logger.logger_name).is_equal("UI")
	assert_bool(logger.enabled).is_true()

	# Getting the same logger again should return the same instance
	var logger2: PrettyLogger = LoggerFactory.get_logger("UI")
	assert_object(logger).is_same(logger2)

func test_logger_factory_with_config() -> void:
	var logger: PrettyLogger = LoggerFactory.get_logger("Network", {
		"log_level": Log.Levels.DEBUG,
		"show_timestamps": true,
		"disable_colors": true
	})

	assert_that(logger.log_level).is_equal(Log.Levels.DEBUG)
	assert_bool(logger.show_timestamps).is_true()
	assert_bool(logger.disable_colors).is_true()

func test_logger_enable_disable() -> void:
	var logger: PrettyLogger = LoggerFactory.get_logger("DisableTest")

	assert_bool(logger.is_enabled()).is_true()

	logger.disable_logger()
	assert_bool(logger.is_enabled()).is_false()

	logger.enable_logger()
	assert_bool(logger.is_enabled()).is_true()

func test_logger_factory_builder() -> void:
	var logger: PrettyLogger = LoggerFactory.builder("GameLogic")\
		.with_level(Log.Levels.DEBUG)\
		.with_timestamps(true)\
		.with_colors(false)\
		.build()

	assert_that(logger.logger_name).is_equal("GameLogic")
	assert_that(logger.log_level).is_equal(Log.Levels.DEBUG)
	assert_bool(logger.show_timestamps).is_true()
	assert_bool(logger.disable_colors).is_true()

func test_logger_factory_bulk_operations() -> void:
	var logger1: PrettyLogger = LoggerFactory.get_logger("Logger1")
	var logger2: PrettyLogger = LoggerFactory.get_logger("Logger2")

	# Test disable all
	LoggerFactory.disable_all()
	assert_bool(logger1.is_enabled()).is_false()
	assert_bool(logger2.is_enabled()).is_false()

	# Test enable all
	LoggerFactory.enable_all()
	assert_bool(logger1.is_enabled()).is_true()
	assert_bool(logger2.is_enabled()).is_true()

	# Test set all log levels
	LoggerFactory.set_all_log_levels(Log.Levels.ERROR)
	assert_that(logger1.log_level).is_equal(Log.Levels.ERROR)
	assert_that(logger2.log_level).is_equal(Log.Levels.ERROR)

func test_logger_configuration() -> void:
	var logger: PrettyLogger = PrettyLogger.new()
	logger.logger_name = "ConfigTest"
	logger.log_level = Log.Levels.DEBUG
	logger.show_timestamps = true
	logger.max_array_size = 50

	var config: Dictionary = logger.get_config()
	assert_that(config[Log.KEY_LOG_LEVEL]).is_equal(Log.Levels.DEBUG)
	assert_bool(config[Log.KEY_SHOW_TIMESTAMPS]).is_true()
	assert_that(config[Log.KEY_MAX_ARRAY_SIZE]).is_equal(50)

func test_logger_level_filtering() -> void:
	var logger: PrettyLogger = PrettyLogger.new()
	logger.logger_name = "LevelTest"
	logger.log_level = Log.Levels.WARN

	# Should not log debug or info
	assert_bool(logger._should_log(Log.Levels.DEBUG)).is_false()
	assert_bool(logger._should_log(Log.Levels.INFO)).is_false()

	# Should log warn and error
	assert_bool(logger._should_log(Log.Levels.WARN)).is_true()
	assert_bool(logger._should_log(Log.Levels.ERROR)).is_true()

func test_logger_names_and_cleanup() -> void:
	LoggerFactory.get_logger("Alpha")
	LoggerFactory.get_logger("Beta")
	LoggerFactory.get_logger("Gamma")

	var names: Array = LoggerFactory.get_logger_names()
	assert_array(names).contains_exactly(["Alpha", "Beta", "Gamma"])

	assert_bool(LoggerFactory.has_logger("Alpha")).is_true()
	assert_bool(LoggerFactory.has_logger("NonExistent")).is_false()

	LoggerFactory.remove_logger("Beta")
	assert_bool(LoggerFactory.has_logger("Beta")).is_false()

	LoggerFactory.clear_all()
	assert_array(LoggerFactory.get_logger_names()).is_empty()

func test_pretty_logger_output_format() -> void:
	var logger: PrettyLogger = PrettyLogger.new()
	logger.logger_name = "FormatTest"

	# Test that logger name appears in output
	var result: String = logger.to_printable(["test message"])
	assert_str(result).contains("(FormatTest)")

	# Test with timestamps enabled
	logger.show_timestamps = true
	var result_with_timestamp: String = logger.to_printable(["test"])
	# Should contain timestamp format
	# TODO test more of the TS format
	assert_str(result_with_timestamp).contains("[")
