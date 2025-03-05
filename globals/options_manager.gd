extends Node

signal options_changed(option:String)

var default_options:Dictionary = {
	"screen_shake": {"intensity": 0.5},
	"texture": {"quality": 1.0}
}

var config: ConfigFile = ConfigFile.new()

func _ready():
	load_options()

func get_option(section: String, key: String):
	if config.has_section_key(section, key):
		return config.get_value(section, key)
	elif default_options.has(section) and default_options[section].has(key):
		config.set_value(section, key, default_options[section][key])
		save_options()
		return config.get_value(section, key)
	print("dont exists a SECTION (" + section + ") or a KEY (" + key + ") in default_options - OptionsManager")
	return null

func set_option(section: String, key: String, value):
	config.set_value(section, key, value)
	options_changed.emit(section + "-" + key)

func save_options() -> void:
	config.save("user://options.cfg")

func load_options() -> void:
	var err = config.load("user://options.cfg")
	if err != OK:
		config = ConfigFile.new()
