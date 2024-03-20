@tool
extends EditorPlugin
const Utils = preload("Utils.gd")
const PluginSettings = preload("scene/plugin_settings/PluginSettings.tscn")

var plugin_config = ConfigFile.new()
var plugin_settings = PluginSettings.instantiate()
var plugins_tab
var plugins_tab_update_btn


func _enter_tree():
	add_control_to_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_LEFT, plugin_settings)
	plugin_settings.connect("updated", _on_plugin_settings_updated)
	plugin_settings.connect("gd_plug_loaded", _on_plugin_settings_gd_plug_loaded)
	var tab_container = plugin_settings.get_parent()
	for child in tab_container.get_children():
		if child.name == "Plugins":
			plugins_tab = child
			break
	if plugins_tab:
		tab_container.move_child(plugin_settings, plugins_tab.get_index())
	else:
		tab_container.move_child(plugin_settings, tab_container.get_child_count()-1)

	for child in plugins_tab.get_children():
		if child is HBoxContainer:
			for grandchild in child.get_children():
				if grandchild is Button:
					if grandchild.text == "Update":
						plugins_tab_update_btn = grandchild
						plugins_tab_update_btn.connect("pressed", self, "_on_plugins_tab_update_btn_pressed")
						break
	plugin_settings.load_gd_plug()

func _on_plugin_settings_gd_plug_loaded(gd_plug):
	check_compatibility(gd_plug.VERSION)

func _on_plugin_settings_updated():
	plugins_tab_update_btn.emit_signal("pressed") # Programmatically press update button in "Plugins" tab

func _exit_tree():
	if is_instance_valid(plugin_settings):
		remove_control_from_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_LEFT, plugin_settings)
		plugin_settings.queue_free()

func check_compatibility(gd_plug_version):
	plugin_config.load("res://addons/gd-plug-ui/plugin.cfg")
	var gd_plug_ui_version = plugin_config.get_value("plugin", "version", "0.0.0")
	var later_or_equal = ""
	var before = ""
	match gd_plug_ui_version:
		"0.2.0":
			later_or_equal = "0.2.5"
		"0.1.0":
			later_or_equal = "0.1.4"
			before = "0.2.0"
		"0.0.0":
			print("Failed to read gd-plug-ui version string")
		_:
			later_or_equal = "0.1.3"

	var is_version_expected = Utils.expected_version(gd_plug_version, later_or_equal, before)
	if not is_version_expected:
		var dialog = AcceptDialog.new()
		var text = "gd-plug-ui(%s) is not compatible with " % gd_plug_ui_version
		text += "current gd-plug(%s), " % gd_plug_version
		text += "expected >=%s" % later_or_equal if before.length() == 0 else " expected >=%s or %s<" % [later_or_equal, before]
		dialog.dialog_text = text
		plugin_settings.add_child(dialog)
		# add_control_to_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_LEFT, dialog)
		dialog.popup_centered()

		await dialog.confirmed

		dialog.queue_free()
		if is_instance_valid(plugin_settings):
			remove_control_from_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_LEFT, plugin_settings)
			plugin_settings.queue_free()
