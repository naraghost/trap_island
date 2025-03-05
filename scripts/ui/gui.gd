extends Control

@onready var player:PlayerCharacter = get_tree().get_first_node_in_group("player")

@onready var health_bar:ProgressBar = $PlayerIcon/Health
@onready var damage_bar:ProgressBar = $PlayerIcon/DamagedHealth
@onready var upd_health_timer:Timer = $PlayerIcon/Timer

@onready var fps_counter:Label = $fps_counter

func _ready():
	player.player_damaged.connect(player_damaged)
	setup_health()

func setup_health():
	health_bar.value = player.health
	damage_bar.value = player.health

var can_upd_health:bool = false
var health_target:float = 100.0

func _process(delta):
	if player: health_bar.value = lerp(float(health_bar.value), player.health, delta * 6)
	damage_bar.value = lerp(float(damage_bar.value), health_target, delta * 6)
	
	var fps:float = Engine.get_frames_per_second()
	fps_counter.text = "FPS: " + str(fps)
	if fps < 30:
		fps_counter.modulate = Color(1,0,0,1)
	elif fps_counter.modulate == Color(1,0,0,1):
		fps_counter.modulate = Color(1,1,1,1)

func player_damaged():
	upd_health_timer.start()

func update_health():
	health_target = player.health
