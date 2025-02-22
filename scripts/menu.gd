class_name MainMenu extends Control

@export var button_container: Control

func _ready() -> void:
	#Get all children that inherit from BaseButton
	var buttons := button_container.find_children('', 'BaseButton')
	buttons[0].grab_focus()
	
	for button: BaseButton in buttons:
		#Check if a method with the button's name exists in this script
		if not has_method(button.name):
			#Otherwise, print a warning
			push_warning('%s is not implemented yet' % button.name)
			continue
		#Connect the button's clicked signal to a method with the same name
		button.button_up.connect(Callable(self, button.name))

func campaign() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func quit() -> void:
	get_tree().quit()
