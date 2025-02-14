class_name MainMenu extends Control

@onready var campaing_button: TextureButton = %Campagin
@onready var options_button: TextureButton = %Options
@onready var extras_button: TextureButton = %Extras
@onready var achievement_button: TextureButton = %Achievement
@onready var credits_button: TextureButton = %Credits
@onready var quit_button: TextureButton = %Quit


func _ready() -> void:
	campaing_button.grab_focus()

	campaing_button.pressed.connect(on_campaing)
	options_button.pressed.connect(on_options)
	extras_button.pressed.connect(on_extra)
	achievement_button.pressed.connect(on_achievement)
	credits_button.pressed.connect(on_credits)
	quit_button.pressed.connect(on_quit)


func on_campaing() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func on_options() -> void:
	push_warning("Not implemented yet")
	pass


func on_extra() -> void:
	push_warning("Not implemented yet")
	pass


func on_achievement() -> void:
	push_warning("Not implemented yet")
	pass


func on_credits() -> void:
	push_warning("Not implemented yet")
	pass


func on_quit() -> void:
	get_tree().quit()
