extends Node
class_name StaticOptimize



static func change_texture_quality(texture: Texture2D) -> Texture2D:
	var texture_quality:float = 1.0
	if !Engine.is_editor_hint():
		texture_quality = OptionsManager.get_option("texture", "quality")
	var img = texture.get_image()
	img.resize(max(1,int(img.get_width() * texture_quality)), max(1,int(img.get_height() * texture_quality)), Image.INTERPOLATE_NEAREST)
	return ImageTexture.create_from_image(img)
