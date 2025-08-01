@tool
extends EditorPlugin

func _enter_tree():
	Log.setup_config()
	ProjectSettings.settings_changed.connect(on_settings_changed)

func on_settings_changed():
	# TODO only run if some log-specific setting has changed
	Log.setup_config()
