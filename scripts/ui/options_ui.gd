extends VBoxContainer
class_name OptionsUI

@export var shake_slider: Slider

func show_options():
	show()
	shake_slider.value = OptionsManager.get_screen_shake_intensity()

func _on_back_button_button_up() -> void:
	hide()

func _on_shake_value_changed(value: float):
	OptionsManager.set_screen_shake_intensity(value)
	OptionsManager.save_options()
