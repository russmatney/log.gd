@tool
extends EditorPlugin

var editor_settings

func _enter_tree():
	editor_settings = get_editor_interface().get_editor_settings()
	editor_settings.settings_changed.connect(on_settings_changed)

	Log.setup_config(editor_settings)

func on_settings_changed():
	if editor_settings.check_changed_settings_in_group(Log.KEY_PREFIX):
		var changed_keys = editor_settings.get_changed_settings()
		Log.setup_config(editor_settings, {updated_keys=changed_keys})
