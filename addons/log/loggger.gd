extends RefCounted
class_name Loggger

# var log_file_path: String = "user://log.txt"

## Logger internal

func _create_log(message: String) -> void:
	print_rich(message) # pretty print the thing

	# print(message) # clean/get a stripped version?

	# Append log message to file

func get_logs() -> Array:
	return []

func clear_logs() -> void:
	pass

func delete_log_file() -> void:
	pass

## Public API

func _pr(...msgs: Array) -> void:
	_create_log(Log.to_pretty.callv(msgs))

func _prn(...msgs: Array) -> void:
	_create_log(Log.to_pretty.callv(msgs))

func _log(...msgs: Array) -> void:
	_create_log(Log.to_pretty.callv(msgs))

func info(...msgs: Array) -> void:
	Log.info.callv(msgs)
	# _create_log(Log.to_pretty.callv(msgs))

func debug(...msgs: Array) -> void:
	Log.debug.callv(msgs)
	# _create_log(Log.to_pretty.callv(msgs))

func warn(...msgs: Array) -> void:
	Log.debug.callv(msgs)
