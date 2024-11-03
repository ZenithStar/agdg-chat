extends HFlowContainer

var selection: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$NoSelection.pressed.connect(_selection_callback.bind(-1))
	for i in AvatarList.avatars.size():
		var new_button: = TextureButton.new()
		new_button.texture_normal = AvatarList.avatars[i]
		new_button.custom_minimum_size = Vector2(128,128)
		new_button.ignore_texture_size = true
		new_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_COVERED
		new_button.pressed.connect(_selection_callback.bind(i))
		add_child.call_deferred(new_button)
		
func _selection_callback(index: int):
	selection = index
	hide()
	$"../VBoxContainer".show()
