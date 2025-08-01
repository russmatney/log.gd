@tool
extends EditorPlugin

func _enter_tree() -> void:
	Log.setup_settings()
	Log.rebuild_config()
	ProjectSettings.settings_changed.connect(on_settings_changed)

func on_settings_changed() -> void:
	# TODO only run if some log-specific setting has changed
	Log.rebuild_config()
