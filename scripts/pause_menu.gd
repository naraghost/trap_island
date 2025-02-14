extends Control

@onready var main_buttons = %MainButtons
@onready var options_ui = %OptionsUI
@onready var options_manager = get_node("/root/OptionsManager")

var is_paused = false

func _ready():
	# Make sure we start unpaused and can process input
	process_mode = Node.PROCESS_MODE_ALWAYS
	is_paused = false
	get_tree().paused = false
	hide()
	
	options_ui.get_node("BackButton").pressed.connect(_on_options_back_pressed)
	options_ui.get_node("ShakeContainer/ShakeSlider").value_changed.connect(_on_shake_value_changed)
	# get_node("CenterContainer/MainButtons/ResumeButton").pressed.connect(_on_resume_pressed)
	# get_node("CenterContainer/MainButtons/OptionsButton").pressed.connect(_on_options_pressed)
	# get_node("CenterContainer/MainButtons/QuitButton").pressed.connect(_on_quit_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		print("Pause key pressed!") # Debug print
		if options_ui.visible:
			_show_main_menu()
		else:
			toggle_pause()
		get_viewport().set_input_as_handled()

func toggle_pause():
	print("Toggling pause. Current state:", is_paused) # Debug print
	is_paused = !is_paused
	
	# Instead of using tree.paused directly, we'll pause specific nodes
	# This prevents the default gray overlay
	var world = get_tree().get_root().get_node("World")
	if world:
		world.process_mode = Node.PROCESS_MODE_DISABLED if is_paused else Node.PROCESS_MODE_INHERIT
	
	visible = is_paused
	if visible:
		_show_main_menu()
	print("New pause state:", is_paused) # Debug print

func _show_main_menu():
	main_buttons.show()
	options_ui.hide()

func _show_options():
	main_buttons.hide()
	options_ui.show()
	options_ui.get_node("ShakeContainer/ShakeSlider").value = options_manager.get_screen_shake_intensity()

func _on_resume_pressed():
	toggle_pause()

func _on_options_pressed():
	_show_options()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_options_back_pressed():
	_show_main_menu()

func _on_shake_value_changed(value: float):
	options_manager.set_screen_shake_intensity(value)
	options_manager.save_options()