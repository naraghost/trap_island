extends MeshInstance3D

@export var fall_speed: float = 6.0 # Faster falling speed
@export var rise_speed: float = 1.0 # Slower rising speed
@export var damage: float = 1.0
@export var max_distance: float = 5.0
@export var anticipation_time: float = 0.3 # Time to pause before falling
@export var impact_pause_time: float = 0.4 # Time to pause at impact
@export var shake_intensity: float = 0.2 # Screen shake intensity on impact
@export var shake_duration: float = 0.2 # Screen shake duration on impact

enum State {WAITING, ANTICIPATING, FALLING, IMPACT_PAUSE, RISING}
var current_state: State = State.WAITING
var initial_position: Vector3
var current_distance: float = 0.0
var timer: float = 0.0
var initial_scale: Vector3

func _ready():
	initial_position = global_position
	initial_scale = scale

func _process(delta):
	match current_state:
		State.WAITING:
			timer = 0.0
			current_state = State.ANTICIPATING

		State.ANTICIPATING:
			timer += delta
			# Slight upward movement for anticipation
			scale.y = initial_scale.y * (1.0 + sin(timer * 10.0) * 0.02)
			if timer >= anticipation_time:
				current_state = State.FALLING
				timer = 0.0

		State.FALLING:
			translate(Vector3.DOWN * fall_speed * delta)
			current_distance += fall_speed * delta
			if current_distance >= max_distance:
				current_state = State.IMPACT_PAUSE
				timer = 0.0
				handle_impact()

		State.IMPACT_PAUSE:
			timer += delta
			# Squash effect during impact
			var squash = 1.0 - (sin(timer * PI / impact_pause_time) * 0.2)
			scale.y = initial_scale.y * squash
			scale.x = initial_scale.x * (1.0 + (1.0 - squash) * 0.5)
			scale.z = initial_scale.z * (1.0 + (1.0 - squash) * 0.5)
			
			if timer >= impact_pause_time:
				current_state = State.RISING

		State.RISING:
			translate(Vector3.UP * rise_speed * delta)
			current_distance -= rise_speed * delta

			# Smoothly return to original scale
			scale = scale.lerp(initial_scale, delta * 5.0)

			if current_distance <= 0:
				current_state = State.WAITING
				current_distance = 0
				global_position = initial_position
				scale = initial_scale

func handle_impact():
	ScreenShake.trigger_shake(global_position, shake_intensity, shake_duration)

func _on_body_entered(body: Node3D):
	if body is PlayerCharacter:
		body.trigger_death()
