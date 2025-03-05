extends Node


func _ready():
	get_viewport().get_window().size = Vector2i(640,360)
	var screen_size:Vector2i = DisplayServer.screen_get_size(0)
	get_viewport().get_window().position = Vector2i(
		screen_size.x / 2 - (640 / 2),
		screen_size.y / 2 - (360 / 2)
	)
