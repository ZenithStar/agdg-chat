class_name CharacterBody3DComponent extends Node

@onready var _body: CharacterBody3D = get_parent()

func _connect_user_signal(signal_id:String, callable:Callable, args:Array[Dictionary]=[]):
	if not _body.has_user_signal(signal_id):
		_body.add_user_signal(signal_id, args)
	_body.connect(signal_id, callable)
	
func _get_configuration_warnings() -> PackedStringArray:
	var output = []
	if not get_parent() is CharacterBody3D:
		output.append("%s requires a CharacterBody3D parent"%[get_class()])
	return PackedStringArray(output)

func _notification(what):
	match what:
		NOTIFICATION_PARENTED:
			update_configuration_warnings ( )
			if get_parent() is CharacterBody3D:
				_body = get_parent()
			else:
				push_error("%s requires a CharacterBody3D parent"%[get_class()])
