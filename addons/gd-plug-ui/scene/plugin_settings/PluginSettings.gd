@tool
extends Control

signal gd_plug_loaded(gd_plug)
signal updated()

enum PLUGIN_STATUS {
	PLUGGED, UNPLUGGED, INSTALLED, CHANGED, UPDATE
}
const PLUGIN_STATUS_ICON = [
	preload("../../assets/icons/add.png"), preload("../../assets/icons/import_fail.png"), 
	preload("../../assets/icons/import_check.png"), preload("../../assets/icons/edit_internal.png"), 
	preload("../../assets/icons/refresh.png")
]

@onready var tree = $Tree
@onready var init_btn = $"%InitBtn"
@onready var check_for_update_btn = $"%CheckForUpdateBtn"
@onready var update_section = $"%UpdateSection"
@onready var force_check = $"%ForceCheck"
@onready var production_check = $"%ProductionCheck"
@onready var update_btn = $"%UpdateBtn"
@onready var loading_overlay = $"%LoadingOverlay"
@onready var loading_label = $"%LoadingLabel"

var gd_plug
var project_dir

var _is_executing = false


func _ready():
	project_dir = DirAccess.open("res://")
	load_gd_plug()
	update_plugin_list(get_plugged_plugins(), get_installed_plugins())

	tree.set_column_title(0, "Name")
	tree.set_column_title(1, "Arguments")
	tree.set_column_title(2, "Status")

	connect("visibility_changed", _on_visibility_changed)

func _process(delta):
	if not is_instance_valid(gd_plug):
		return
	
	if "threadpool" in gd_plug:
		gd_plug.threadpool.process(delta)

func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			if is_instance_valid(gd_plug):
				gd_plug.threadpool.stop()
				gd_plug.free()
		NOTIFICATION_APPLICATION_FOCUS_IN:
			load_gd_plug()
			update_plugin_list(get_plugged_plugins(), get_installed_plugins())

func load_gd_plug():
	if is_instance_valid(gd_plug):
		gd_plug.free() # Free instance in order to reload script
	if project_dir.file_exists("plug.gd"):
		init_btn.hide()
		check_for_update_btn.show()
		update_section.show()
		update_btn.show() # Not sure why it is always hidden

		var gd_plug_script = load("plug.gd")
		gd_plug_script.reload(true) # Reload gd-plug script to get updated
		gd_plug = gd_plug_script.new()
		gd_plug._plug_start()
		gd_plug._plugging()
	else:
		if project_dir.file_exists("addons/gd-plug/plug.gd"):
			init_btn.show()
			check_for_update_btn.hide()
			update_section.hide()
			
			gd_plug = load("addons/gd-plug/plug.gd").new()
		else:
			print("Missing dependency: gd-plug")

	if is_instance_valid(gd_plug):
		emit_signal("gd_plug_loaded", gd_plug)

func update_plugin_list(plugged, installed):
	var plugin_names = []
	for plugin_name in plugged.keys():
		plugin_names.append(plugin_name)
	for plugin_name in installed.keys():
		if plugin_name in plugin_names:
			continue
		plugin_names.append(plugin_name)

	tree.clear()
	tree.create_item() # root
	for plugin_name in plugin_names:
		var plugin_plugged = plugged.get(plugin_name, {})
		var plugin_installed = installed.get(plugin_name, {})
		var plugin = plugin_plugged if plugin_name in plugged else plugin_installed
		var plugin_status = get_plugin_status(plugin_name)
		
		var plugin_args = []
		for plugin_arg in plugin.keys():
			var value = plugin[plugin_arg]
			
			if value != null:
				if not (value is bool):
					if value.is_empty():
						continue
			else:
				continue

			match plugin_arg:
				"install_root":
					plugin_args.append("install root: %s" % str(value))
				"include":
					plugin_args.append("include %s" % str(value))
				"exclude":
					plugin_args.append("exclude %s" % str(value))
				"branch":
					plugin_args.append("branch: %s" % str(value))
				"tag":
					plugin_args.append("tag: %s" % str(value))
				"commit":
					plugin_args.append(str(value).left(8))
				"dev":
					if value:
						plugin_args.append("dev")
				"on_updated":
					plugin_args.append("on_updated: %s" % str(value))
		
		var plugin_args_text = ""
		for i in plugin_args.size():
			var text = plugin_args[i]
			plugin_args_text += text
			if i < plugin_args.size() - 1:
				plugin_args_text += ", "
		
		var child = tree.create_item(tree.get_root())
		child.set_text_alignment(0, HORIZONTAL_ALIGNMENT_LEFT)
		child.set_text_alignment(1, HORIZONTAL_ALIGNMENT_CENTER)
		child.set_text_alignment(2, HORIZONTAL_ALIGNMENT_CENTER)
		child.set_meta("plugin", plugin)
		child.set_text(0, plugin_name)
		child.set_tooltip_text(0, plugin.url)
		child.set_text(1, plugin_args_text)
		child.set_tooltip_text(2, PLUGIN_STATUS.keys()[plugin_status].capitalize())
		child.set_icon(2, PLUGIN_STATUS_ICON[plugin_status])

func disable_ui(disabled=true):
	init_btn.disabled = disabled
	check_for_update_btn.disabled = disabled
	update_btn.disabled = disabled

func show_overlay(show=true, text=""):
	loading_overlay.visible = show
	loading_label.text = text

func gd_plug_execute_threaded(name):
	if not is_instance_valid(gd_plug):
		return
	if _is_executing:
		return
	
	_is_executing = true
	disable_ui(true)
	gd_plug._plug_start()
	gd_plug._plugging()
	gd_plug.call(name)
	
	await gd_plug.threadpool.all_thread_finished

	gd_plug._plug_end()
	disable_ui(false)
	_is_executing = false
	clear_environment()

	update_plugin_list(get_plugged_plugins(), get_installed_plugins())

func gd_plug_execute(name):
	if not is_instance_valid(gd_plug):
		return
	if _is_executing:
		return
	
	_is_executing = true
	disable_ui(true)
	gd_plug._plug_start()
	gd_plug._plugging()
	gd_plug.call(name)
	gd_plug._plug_end()
	disable_ui(false)
	_is_executing = false
	clear_environment()

	update_plugin_list(get_plugged_plugins(), get_installed_plugins())

func clear_environment():
	OS.unset_environment("production")
	OS.unset_environment("test")
	OS.unset_environment("force")

func _on_visibility_changed():
	if visible:
		load_gd_plug()
		update_plugin_list(get_plugged_plugins(), get_installed_plugins())

func _on_Init_pressed():
	gd_plug_execute("_plug_init")
	load_gd_plug()

func _on_CheckForUpdateBtn_pressed():
	var children = tree.get_root().get_children()
	if tree.get_root().get_children().size() > 0:
		show_overlay(true, "Updating...")
		gd_plug.threadpool.enqueue_task(check_for_update.bind(children[0]))
		disable_ui(true)

		await gd_plug.threadpool.all_thread_finished
	
	disable_ui(false)
	show_overlay(false)

func _on_UpdateBtn_pressed():
	if force_check.pressed:
		OS.set_environment("force", "true")
	if production_check.pressed:
		OS.set_environment("production", "true")
	show_overlay(true, "Updating...")
	gd_plug_execute_threaded("_plug_install")

	await gd_plug.threadpool.all_thread_finished

	show_overlay(false)
	emit_signal("updated")

func get_plugged_plugins():
	return gd_plug._plugged_plugins if is_instance_valid(gd_plug) else {}

func get_installed_plugins():
	return gd_plug.installation_config.get_value("plugin", "installed", {}) if is_instance_valid(gd_plug) else {}

func get_plugin_status(plugin_name):
	var plugged_plugins = get_plugged_plugins()
	var installed_plugins = get_installed_plugins()
	var plugin_plugged = plugged_plugins.get(plugin_name, {})
	var plugin_installed = installed_plugins.get(plugin_name, {})
	var plugin = plugin_plugged if plugin_name in plugged_plugins else plugin_installed

	var is_plugged = plugin.name in plugged_plugins
	var is_installed = plugin.name in installed_plugins
	var changes = gd_plug.compare_plugins(plugin_plugged, plugin_installed) if is_installed else {}
	var is_changed = changes.size() > 0

	var plugin_status = 0
	if is_installed:
		if is_plugged:
			if is_changed:
				plugin_status = 3
			else:
				plugin_status = 2
		else:
			plugin_status = 1
	else:
		plugin_status = 0

	return plugin_status

func has_update(plugin):
	if not is_instance_valid(gd_plug):
		return false
	if plugin == null:
		return false
	var git = gd_plug._GitExecutable.new(ProjectSettings.globalize_path(plugin.plug_dir), gd_plug.logger)

	var ahead_behind = []
	if git.fetch("origin " + plugin.branch if plugin.branch else "origin").exit == OK:
		ahead_behind = git.get_commit_comparison("HEAD", "origin/" + plugin.branch if plugin.branch else "origin")
	var is_commit_behind = !!ahead_behind[1] if ahead_behind.size() == 2 else false
	if is_commit_behind:
		gd_plug.logger.info("%s %d commits behind, update required" % [plugin.name, ahead_behind[1]])
		return true
	else:
		gd_plug.logger.info("%s up to date" % plugin.name)
		return false

func check_for_update(child):
	var plugin = child.get_meta("plugin")
	var plugin_status = get_plugin_status(plugin.name)
	if plugin_status == PLUGIN_STATUS.INSTALLED:
		var has_update = has_update(plugin)
		if has_update:
			child.set_icon(2, PLUGIN_STATUS_ICON[PLUGIN_STATUS.UPDATE])
			child.set_tooltip_text(2, PLUGIN_STATUS.keys()[PLUGIN_STATUS.UPDATE].capitalize())
	var next_child = child.get_next()
	if next_child:
		check_for_update(next_child)
