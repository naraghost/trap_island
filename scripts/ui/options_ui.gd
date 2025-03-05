extends VBoxContainer
class_name OptionsUI

@export var shake_slider: Slider = null
@export var quality_slider: Slider = null

func show_options():
	show()
	
	# ALGO PROVISORIO - FAZER UM SISTEMA QUE FAZ ISSO AUTOMATICAMENTE
	shake_slider.value = OptionsManager.get_option("screen_shake", "intensity")
	print(OptionsManager.get_option("texture", "quality"))
	quality_slider.value = OptionsManager.get_option("texture", "quality")

func _on_back_button_button_up() -> void:
	OptionsManager.set_option("texture", "quality", quality_slider.value)
	OptionsManager.save_options()
	hide()

func _on_shake_value_changed(value: float):
	OptionsManager.set_option("screen_shake", "intensity", shake_slider.value)
	OptionsManager.save_options()


func _on_quality_slider_value_changed(value):
	$QualityContainer/info.text = str(quality_slider.value) + "x"
