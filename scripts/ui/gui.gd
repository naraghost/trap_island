extends Control

@onready var player:PlayerCharacter = get_tree().get_first_node_in_group("player")

@onready var health_bar:ProgressBar = $Health

func _process(delta):
	if player: health_bar.value = lerp(float(health_bar.value), player.HEALTH, delta * 5)
