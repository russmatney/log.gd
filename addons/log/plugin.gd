@tool
extends EditorPlugin


var override_log_level_option_button: OptionButton = OptionButton.new()

var icon_debug: Texture2D = EditorInterface.get_editor_theme().get_icon("Debug", "EditorIcons")
var icon_info: Texture2D = EditorInterface.get_editor_theme().get_icon("NodeInfo", "EditorIcons")
var icon_warn: Texture2D = EditorInterface.get_editor_theme().get_icon("NodeWarning", "EditorIcons")
var icon_err: Texture2D = EditorInterface.get_editor_theme().get_icon("StatusError", "EditorIcons")


func _enter_tree() -> void:
	override_log_level_option_button.visible = ProjectSettings.get_setting("log_gd/config/show_log_level_selector", false)
	override_log_level_option_button.add_icon_item(icon_debug, "DEBUG")
	override_log_level_option_button.add_icon_item(icon_info, "INFO")
	override_log_level_option_button.add_icon_item(icon_warn, "WARN")
	override_log_level_option_button.add_icon_item(icon_err, "ERROR")
	override_log_level_option_button.select(Log.get_log_level())
	override_log_level_option_button.item_selected.connect(override_log_level)
	add_control_to_container(CONTAINER_TOOLBAR, override_log_level_option_button)
	override_log_level_option_button.get_parent().move_child(override_log_level_option_button, override_log_level_option_button.get_index() - 2)

	Log.setup_settings()
	Log.rebuild_config()
	# TODO only run if some log-specific setting has changed
	ProjectSettings.settings_changed.connect(on_settings_changed)


func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_TOOLBAR, override_log_level_option_button)


func on_settings_changed() -> void:
	override_log_level_option_button.select(ProjectSettings.get_setting("log_gd/config/log_level"))
	override_log_level_option_button.visible = ProjectSettings.get_setting("log_gd/config/show_log_level_selector")
	Log.rebuild_config()


func override_log_level(value: Log.Levels) -> void:
	Log.set_log_level(value)
	ProjectSettings.set_setting("log_gd/config/log_level", value)
