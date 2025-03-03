extends CharacterBody3D
class_name Enemy

# @onready var player:PlayerCharacter = get_tree().get_first_node_in_group("player")

@export var enemy_damage:int = 25
@export var enemy_health:int = 50

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _on_player_entered(player:PlayerCharacter):
	print("player damaged!")
	var distance:Vector3 = player.position - position
	var force:Vector3 = Vector3(
		distance.x * 40, 1, distance.z * 40
	)
	player.take_damage(enemy_damage, force)
