class_name SprintCommand extends ControllerComponent

@export var sprint_input: String = "sprint"

func _set_target(value):
	target = value
	if target:
		if not target.has_user_signal("sprint_begin"):
			target.add_user_signal("sprint_begin")
		if not target.has_user_signal("sprint_end"):
			target.add_user_signal("sprint_end")

func _unhandled_input(event: InputEvent):
	if target and event.is_action(sprint_input) and not event.is_echo():
		if event.is_pressed():
			target.emit_signal("sprint_begin")
		else:
			target.emit_signal("sprint_end")
		get_viewport().set_input_as_handled()
