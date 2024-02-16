@tool
extends CanvasLayer


func _ready():
	Log.pr("Hi there!", [1, 2.0, Vector2(3, 4)])
	Log.prn("Hi there!", [1, 2.0, Vector2(3, 4)])
