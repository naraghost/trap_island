extends CharacterBody3D

class_name PlayerCharacter

@export var SPEED = 1.3
@export var JUMP_VELOCITY = 3
@export var ACCELERATION = 200.0
@export var FRICTION = 100.0

@onready var shadow_sprite: Sprite3D = $ShadowGradient
@onready var ground_ray: RayCast3D = $ShadowRaycast
@onready var debug_label: Label3D = $DebugLabel
@onready var player_sprite: AnimatedSprite3D = $AnimatedSprite3D

# Example custom animator. If you have your own, adjust as needed.
@onready var animator: PlayerAnimator = PlayerAnimator.new(player_sprite)

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_dying = false
var walk_tween: Tween
var death_tween: Tween

var base_sprite_scale = Vector3.ONE
var base_sprite_rotation_degrees = Vector3(-30, 45, 0)

var is_walk_animation_active = false

func _ready():
	# Store the initial sprite scale, and force the rotation so it matches the isometric camera.
	base_sprite_scale = Vector3.ONE  # Set a known initial scale
	player_sprite.scale = base_sprite_scale  # Apply it to the sprite
	player_sprite.rotation_degrees = base_sprite_rotation_degrees
	print("Initial scale set to: ", base_sprite_scale)  # Debug print

func _physics_process(delta):
	if is_dying:
		return

	update_shadow()

	# If the player fell below a certain height, trigger death
	if global_position.y < -5:
		trigger_death()
		return

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input for movement
	var input_dir = Vector2(
		Input.get_action_strength("w_right") - Input.get_action_strength("w_left"),
		Input.get_action_strength("w_down") - Input.get_action_strength("w_up")
	).normalized()

	# Convert 2D input to "isometric" 3D direction
	var direction = Vector3(
		input_dir.x + input_dir.y,  # X axis
		0,
		- input_dir.x + input_dir.y # Z axis
	).normalized()

	# Accelerate / decelerate in XZ plane
	if direction.length() > 0.01:
		var target_velocity = direction * SPEED
		velocity.x = move_toward(velocity.x, target_velocity.x, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, ACCELERATION * delta)

		# Start walk-squish if not active
		if not is_walk_animation_active:
			print("Starting walk animation")  # Debug print
			apply_walk_squish()
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)

		# Stop walk-squish if the player stops
		if is_walk_animation_active:
			print("Stopping walk animation")  # Debug print
			reset_walk_squish()

	move_and_slide()

	# Update animated sprite if velocity is high enough
	var velocity_2d = Vector2(velocity.x, velocity.z)
	if velocity_2d.length() > 0.1:
		animator.update_animation(velocity_2d, delta) # or whatever your animator expects
	else:
		animator.set_idle()


# -- Walking "Squish" Tween -

func apply_walk_squish():
		# Stop any existing walk animation tween
		if walk_tween:
				walk_tween.kill()
				print("Killed existing walk tween")  # Debug print

		is_walk_animation_active = true
		walk_tween = create_tween()
		
		# Make the tween loop forever while the character is walking
		walk_tween.set_loops(-1)  # Explicitly set to infinite loops
		walk_tween.set_trans(Tween.TRANS_SINE)
		walk_tween.set_ease(Tween.EASE_IN_OUT)

		var squish_duration = 0.25  # Slightly slower
		var squish_amount = 0.05    # More pronounced squish
		
		print("Setting up new walk tween with duration:", squish_duration, " and amount:", squish_amount)
		
		# PHASE 1: Squish vertically, stretch horizontally
		walk_tween.parallel().tween_property(
				player_sprite, 
				"scale", 
				Vector3(base_sprite_scale.x * (1.0 + squish_amount), 
						base_sprite_scale.y * (1.0 - squish_amount),
						base_sprite_scale.z), 
				squish_duration
		).set_trans(Tween.TRANS_SINE)
		
		# PHASE 2: Stretch vertically, squish horizontally
		walk_tween.chain().tween_property(
				player_sprite, 
				"scale", 
				Vector3(base_sprite_scale.x * (1.0 - squish_amount), 
						base_sprite_scale.y * (1.0 + squish_amount),
						base_sprite_scale.z), 
				squish_duration
		).set_trans(Tween.TRANS_SINE)
		
		print("Tween setup complete. Is active:", walk_tween.is_valid(), " Is running:", walk_tween.is_running())
		
func reset_walk_squish():
	is_walk_animation_active = false
	if walk_tween:
		walk_tween.kill()
		print("Walk tween killed in reset")

	# Tween back to original scale smoothly
	var reset_tween = create_tween()
	reset_tween.set_trans(Tween.TRANS_SINE)
	reset_tween.set_ease(Tween.EASE_OUT)
	reset_tween.tween_property(player_sprite, "scale", base_sprite_scale, 0.2)


# -- Death & Respawn --

func trigger_death():
	if is_dying:
		return

	is_dying = true

	# Kill any walking tween
	if walk_tween:
		walk_tween.kill()

	# Kill previous death tween if it exists
	if death_tween:
		death_tween.kill()

	death_tween = create_tween()
	death_tween.set_trans(Tween.TRANS_CUBIC)
	death_tween.set_ease(Tween.EASE_IN_OUT)

	# Spin around local Y by 360° and shrink to zero
	death_tween.parallel().tween_property(player_sprite, "rotation_degrees:y", player_sprite.rotation_degrees.y + 360, 0.5)
	death_tween.parallel().tween_property(player_sprite, "scale", Vector3.ZERO, 0.5)

	# After animation completes, respawn
	death_tween.tween_callback(func():
		respawn()
		reset_death_state()
	)

func reset_death_state():
	is_dying = false
	player_sprite.rotation_degrees = base_sprite_rotation_degrees
	player_sprite.scale = base_sprite_scale

func respawn():
	global_position = Vector3(1, 2, 0)
	velocity = Vector3.ZERO


# -- Shadow Handling --

func update_shadow():
	if not shadow_sprite or not ground_ray:
		return

	if ground_ray.is_colliding():
		var collision_point = ground_ray.get_collision_point()
		var height_diff = global_position.y - collision_point.y

		# Lock player slightly above ground if needed
		if height_diff < 0.01:
			global_position.y = collision_point.y + 0.01
			height_diff = 0.01

		if debug_label:
			debug_label.text = "Ray Hit\nHeight: %.2f" % height_diff
			debug_label.modulate = Color.GREEN

		if height_diff >= 0 and height_diff < 2.0:
			# Offset the shadow a bit for isometric style
			shadow_sprite.global_position = collision_point + Vector3(0.05, 0.05, 0.05)

			var distance = global_position.distance_to(collision_point)
			var scale_factor = clamp(1.0 + (distance / 5.0), 1.0, 2.5)
			shadow_sprite.scale = Vector3(scale_factor, scale_factor, 1.0)
			shadow_sprite.visible = true
		else:
			shadow_sprite.visible = false
	else:
		if debug_label:
			debug_label.text = "No Hit"
			debug_label.modulate = Color.RED
		shadow_sprite.visible = false
