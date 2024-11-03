class_name JumpCommand extends ControllerComponent

@export var jump_input: String = "jump"

func _set_target(value):
	target = value
	if target:
		if not target.has_user_signal("jump_begin"):
			target.add_user_signal("jump_begin")
		if not target.has_user_signal("jump_end"):
			target.add_user_signal("jump_end")

func _unhandled_input(event: InputEvent):
	if target and event.is_action(jump_input) and not event.is_echo():
		if event.is_pressed():
			target.emit_signal("jump_begin")
		else:
			target.emit_signal("jump_end")
		get_viewport().set_input_as_handled()
