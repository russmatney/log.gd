@tool
extends EditorPlugin

var reload_scene_btn: Button = Button.new()

func _enter_tree() -> void:
	Log.setup_settings()
	Log.rebuild_config()
	# TODO only run if some log-specific setting has changed
	ProjectSettings.settings_changed.connect(on_settings_changed)

	# TODO does not belong in log.gd... maybe needs a small scale dev-editor addon to house this
	reload_scene_btn.pressed.connect(reload_scene)
	reload_scene_btn.text = "Reload"
	add_control_to_container(CONTAINER_TOOLBAR, reload_scene_btn)
	reload_scene_btn.get_parent().move_child(reload_scene_btn, reload_scene_btn.get_index() - 2)


func on_settings_changed() -> void:
	Log.rebuild_config()


func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_TOOLBAR, reload_scene_btn)

func reload_scene() -> void:
	print("-------------------------------------------------")
	Log.info("[ReloadScene] ", Time.get_time_string_from_system())
	var edited_scene := EditorInterface.get_edited_scene_root()
	Log.info("edited scene", edited_scene, ".scene_file_path", edited_scene.scene_file_path)
	EditorInterface.reload_scene_from_path(edited_scene.scene_file_path)
	print("-------------------------------------------------")
