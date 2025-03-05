@tool
extends Cube

var lava_speed:float = 0.005
var initial_offset:Vector2 = tile_offset

#func _process(delta):
	#tile_offset.x = wrapf(tile_offset.x + lava_speed, initial_offset.x, initial_offset.x + 1)
	#tile_offset.y = wrapf(tile_offset.y + lava_speed, initial_offset.y, initial_offset.y + 1)

func _on_body_entered(body: Node3D):
	if body is PlayerCharacter:
		body.trigger_death()
