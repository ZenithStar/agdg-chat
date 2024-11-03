extends CharacterBody3D

func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Returns escaped BBCode that won't be parsed by RichTextLabel as tags.
func escape_bbcode(bbcode_text):
	# We only need to replace opening brackets to prevent tags from being parsed.
	return bbcode_text.replace("[", "[lb]")

@export var user_name: String = "Anonymous":
	set(value):
		user_name = escape_bbcode(value)
		$Nameplate.text = user_name
		

func send_bark( message: String ) -> String:
	bark = escape_bbcode(message)
	var chat_log_string: = "[color=#%s]%s:[/color] %s\n" % [color.to_html(false), user_name if user_name != "" else "Anonymous", bark]
	return chat_log_string

var _bark_tween: Tween
@export var bark: String = "":
	set(value):
		if is_instance_valid(_bark_tween):
			_bark_tween.kill()
		bark = value
		$Bark.text = bark
		$Bark.visible = true
		$Bark.modulate.a = 1.0
		$Bark.outline_modulate.a = 1.0
		_bark_tween = create_tween()
		_bark_tween.tween_interval((bark.length() / 15.0) + 5.0)
		_bark_tween.tween_property($Bark, "modulate:a", 0.0, 0.3)
		_bark_tween.parallel().tween_property($Bark, "outline_modulate:a", 0.0, 0.3)
		_bark_tween.tween_property($Bark, "visible", false, 0.0)

@export var color: Color = Color.DARK_GREEN:
	set(value):
		color = value
		$MeshInstance3D.get_surface_override_material(0).albedo_color = value

@export var portrait_index: int = -1:
	set(value):
		portrait_index = value
		portrait = AvatarList.avatars[portrait_index] if portrait_index >= 0 else null

@export var portrait: Texture2D:
	set(value):
		portrait = value
		if is_instance_valid(portrait):
			$Portrait.texture = portrait
			$Portrait.pixel_size = 1.28/portrait.get_size().x
			$Portrait.show()
		else:
			$Portrait.hide()
