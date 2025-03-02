@tool
extends Node3D

const PLATFORM = preload("res://scenes/prefabs/falling_platform.tscn")

@export var platforms_number:int = 1:
	set(plat_num):
		platforms_number = plat_num
		_upd()

func _upd():
	var childs = get_children()
	for i in childs:
		i.queue_free()
	for i in platforms_number:
		var platform = PLATFORM.instantiate()
		platform.position.z = i * -0.52
		add_child(platform)
