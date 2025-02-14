extends Camera3D

@export var target_path: NodePath
@export var rotation_desired = Vector3(-35, 45, 0)
@export var offset = Vector3(2, 2, 2)
@export var smooth_speed = 4.0
@export var zoom_speed = 0.25
@export var min_zoom = 1.5
@export var max_zoom = 4.5
@export var initial_zoom = 3.0

var target: Node3D

func _ready():
	if target_path:
		target = get_node(target_path)
	self.projection = Camera3D.PROJECTION_ORTHOGONAL
	self.size = initial_zoom
	rotation_degrees = rotation_desired

func _physics_process(delta):
	if not target:
		return
	
	var desired_position = target.global_transform.origin + offset
	var current_pos = global_transform.origin
	
	global_transform.origin = Vector3(
		lerp(current_pos.x, desired_position.x, smooth_speed * delta),
		desired_position.y,
		lerp(current_pos.z, desired_position.z, smooth_speed * delta)
	)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.size = clamp(self.size - zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.size = clamp(self.size + zoom_speed, min_zoom, max_zoom)
