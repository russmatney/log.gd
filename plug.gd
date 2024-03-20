extends "res://addons/gd-plug/plug.gd"

func _plugging():
	# Declare plugins with plug(repo, args)
	# plug("imjp94/gd-YAFSM") # By default, gd-plug will only install anything from "addons/" directory
	# plug("imjp94/gd-YAFSM", {"include": ["addons/"]}) # By default, gd-plug will only install anything from "addons/" directory
	plug("MikeSchulze/gdUnit4")
