extends Control

@onready var main_buttons = %MainButtons
@onready var options_ui = %OptionsUI
@onready var options_manager = get_node("/root/OptionsManager")

func _ready():
	options_manager.load_options()
	options_ui.get_node("BackButton").pressed.connect(_on_options_back_pressed)
	options_ui.get_node("ShakeContainer/ShakeSlider").value_changed.connect(_on_shake_value_changed)
	_show_main_menu()

func _show_main_menu():
	main_buttons.show()
	options_ui.hide()

func _show_options():
	main_buttons.hide()
	options_ui.show()
	options_ui.get_node("ShakeContainer/ShakeSlider").value = options_manager.get_screen_shake_intensity()

func _on_play_button_pressed():
	# Change to the main game scene
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_button_pressed():
	_show_options()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_options_back_pressed():
	_show_main_menu()

func _on_shake_value_changed(value: float):
	options_manager.set_screen_shake_intensity(value)
	options_manager.save_options()