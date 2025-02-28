extends Node3D
class_name PlayerAnimator

const IDLE_THRESHOLD: float = 0.1
const DIRECTION_SECTORS: Array[Array] = [
	# start, end, animation, flip_h
	[-180.0, -157.5, "up_side", true],
	[-157.5, -112.5, "up", false],
	[-112.5, -67.5, "up_side", false],
	[-67.5, -22.5, "side", false],
	[-22.5, 22.5, "down_side", false],
	[22.5, 67.5, "down", false],
	[67.5, 112.5, "down_side", true],
	[112.5, 157.5, "side", true],
	[157.5, 180.0, "up_side", true]
]

var sprite: AnimatedSprite3D
var animation:String = "idle"
var current_animation: String = "idle_down"
var last_direction: Vector2 = Vector2.DOWN

func _init(_sprite: AnimatedSprite3D) -> void:
	sprite = _sprite

func _ready() -> void:
	sprite.play(current_animation)

func update_animation(velocity: Vector2, _delta: float) -> void:
	if velocity.length() < IDLE_THRESHOLD:
		set_direction(last_direction)
	else:
		last_direction = velocity
		set_direction(velocity)

func set_direction(direction: Vector2) -> void:
	var normalized_dir := direction.normalized()
	var angle := rad_to_deg(normalized_dir.angle())
	var animation_data := get_animation_for_angle(angle)
	
	sprite.flip_h = animation_data[1]
	if animation_data[0] != current_animation:
		current_animation = animation+"_"+animation_data[0]
		sprite.play(current_animation)

func get_animation_for_angle(angle: float) -> Array:
	for sector in DIRECTION_SECTORS:
		if angle > sector[0] and angle <= sector[1]:
			return [sector[2], sector[3]]
	return ["up_side", true] # Fallback (should never be reached)

func set_idle() -> void:
	set_direction(last_direction)
