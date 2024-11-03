extends ColorRect

var _fade_tween: Tween
@export var fade_show: bool:
	get:
		return visible
	set(value):
		if visible != value:
			if is_instance_valid(_fade_tween):
				_fade_tween.kill()
			_fade_tween = create_tween()
			if value:
				_fade_tween.tween_property(self, "color:a", 0.0, 0.0)
				_fade_tween.tween_property(self, "visible", true, 0.0)
			else:
				_fade_tween.tween_property($VBoxContainer, "visible", false, 0.0)
			_fade_tween.tween_property(self, "color:a", 1.0 if value else 0.0, 0.5)
			if value:
				_fade_tween.tween_property($VBoxContainer, "visible", true, 0.0)
			else:
				_fade_tween.tween_property(self, "visible", false, 0.0)
	


func _on_avatar_menu_pressed() -> void:
	$VBoxContainer.hide()
	$AvatarSelection.show()
