@tool
extends EditorPlugin

func _enter_tree():
	ProjectSettings.settings_changed.connect(on_settings_changed)

func on_settings_changed():
	Log.setup_config()
