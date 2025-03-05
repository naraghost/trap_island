extends Node

const MAX_SHAKE_DISTANCE = 10.0 # Adjust this value based on your game's scale
const DEFAULT_SHAKE_INTENSITY = 0.03
const DEFAULT_SHAKE_DURATION = 0.1

static var _instance: Node = null

static var _shake_time: float = 0.0
static var _shake_intensity: float = DEFAULT_SHAKE_INTENSITY
static var _shake_duration: float = DEFAULT_SHAKE_DURATION
static var _shake_source_position: Vector3

func _ready() -> void:
	_instance = self
	# Connect to options changed signal
	OptionsManager.options_changed.connect(_on_options_changed)

static func trigger_shake(source_position: Vector3, intensity: float = DEFAULT_SHAKE_INTENSITY, duration: float = DEFAULT_SHAKE_DURATION) -> void:
	_shake_source_position = source_position
	# Apply user's screen shake intensity preference
	_shake_intensity = intensity * OptionsManager.get_option("screen_shake","intensity")
	_shake_duration = duration
	_shake_time = duration

func _process(delta: float) -> void:
	if _shake_time > 0:
		_shake_time -= delta
		if is_player_in_range():
			apply_screen_shake()

static func is_player_in_range() -> bool:
	if not _instance:
		return false
		
	var camera = _instance.get_viewport().get_camera_3d()
	if not camera:
		return false
		
	# Find player in scene
	var player = _instance.get_tree().get_first_node_in_group("player")
	if not player:
		return false
		
	# Check distance between shake source and player
	var distance = _shake_source_position.distance_to(player.global_position)
	return distance <= MAX_SHAKE_DISTANCE

func apply_screen_shake() -> void:
	var camera = get_viewport().get_camera_3d()
	if camera:
		var shake_offset = Vector3(
			randf_range(-1.0, 1.0) * _shake_intensity * (_shake_time / _shake_duration),
			randf_range(-1.0, 1.0) * _shake_intensity * (_shake_time / _shake_duration),
			0
		)
		camera.global_position += shake_offset

func _on_options_changed(option) -> void:
	if option == "texture-quality":
		# Update current shake intensity when options change
		if _shake_time > 0:
			_shake_intensity = (_shake_intensity / OptionsManager.get_option("screen_shake","intensity")) * OptionsManager.get_option("screen_shake","intensity")
