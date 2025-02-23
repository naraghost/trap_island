extends Control

@export var options_ui: OptionsUI
@export var main_buttons: Control

var is_paused = false:
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused
		if visible:
			_show_main_menu()

func _ready():
	is_paused = false
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		is_paused = !is_paused
		get_viewport().set_input_as_handled()

func _show_main_menu():
	main_buttons.show()
	options_ui.hide()

func _on_resume_pressed():
	is_paused = false

func _on_options_pressed():
	main_buttons.hide()
	options_ui.show_options()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_options_ui_visibility_changed() -> void:
	if not options_ui.visible:
		_show_main_menu()
