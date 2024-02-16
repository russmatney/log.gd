@tool
extends EditorPlugin


func _enter_tree():
	Log.pr("<Log>")


func _exit_tree():
	Log.pr("</Log>")
