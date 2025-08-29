@tool
extends EditorPlugin


var reload_scene_btn: Button = Button.new()


func _enter_tree() -> void:
	reload_scene_btn.pressed.connect(reload_scene)
	reload_scene_btn.text = "Reload Scene"
	reload_scene_btn.icon = EditorInterface.get_editor_theme().get_icon("Reload", "EditorIcons")
	add_control_to_container(CONTAINER_TOOLBAR, reload_scene_btn)
	reload_scene_btn.get_parent().move_child(reload_scene_btn, reload_scene_btn.get_index() - 2)


func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_TOOLBAR, reload_scene_btn)


func reload_scene() -> void:
	Log.info("[ReloadScene] Reload initialized", Time.get_time_string_from_system())
	var edited_scene: Node = EditorInterface.get_edited_scene_root()
	Log.info("[ReloadScene] Edited scene", "%s.scene_file_path" % edited_scene, edited_scene.scene_file_path)
	EditorInterface.reload_scene_from_path(edited_scene.scene_file_path)
	Log.info("[ReloadScene] Scene reloaded", Time.get_time_string_from_system())
