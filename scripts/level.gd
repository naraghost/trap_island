extends Node3D

@onready var spawn_point:Marker3D = $WorldSpawnPoint

var current_spawn_point:Marker3D = null


func _ready():
	spawn_point.visible = false


func _process(delta):
	pass
