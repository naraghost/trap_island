extends Node

signal options_changed

var screen_shake_intensity: float = 0.5

func set_screen_shake_intensity(value: float) -> void:
	screen_shake_intensity = value
	options_changed.emit()

func get_screen_shake_intensity() -> float:
	return screen_shake_intensity

func save_options() -> void:
	var config = ConfigFile.new()
	config.set_value("screen_shake", "intensity", screen_shake_intensity)
	config.save("user://options.cfg")

func load_options() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://options.cfg")
	if err == OK:
		screen_shake_intensity = config.get_value("screen_shake", "intensity", 0.5)
		options_changed.emit()
