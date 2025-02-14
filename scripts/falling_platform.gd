extends Node3D

@onready var platform: Node3D = $Cube
@onready var area_node: Area3D = $Area3D

func fall():
	# Shake the platform before falling
	var initial_pos = platform.global_position
	var fall_pos = Vector3(initial_pos.x, -3, initial_pos.z)
	
	# Create shake tween
	var shake_tween = create_tween()
	shake_tween.tween_property(platform, "position:y", initial_pos.y + .05, .05)
	shake_tween.tween_property(platform, "position:y", initial_pos.y, .05)
	shake_tween.tween_property(platform, "position:y", initial_pos.y - .05, .05)
	shake_tween.tween_property(platform, "position:y", initial_pos.y, .05)
	shake_tween.set_loops(2)
	
	# Wait before falling
	await get_tree().create_timer(0.5).timeout
	
	# Create fall tween
	var fall_tween = create_tween()
	fall_tween.tween_property(platform, "global_position", fall_pos, 1.0)
	fall_tween.tween_callback(queue_free)


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("area entered")
	if body is PlayerCharacter:
		fall()
