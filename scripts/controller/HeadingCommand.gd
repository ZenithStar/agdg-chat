class_name HeadingCommand extends ControllerComponent

@export var move_x_m: String = "move_left"
@export var move_x_p: String = "move_right"
@export var move_y_m: String = "move_forward"
@export var move_y_p: String = "move_back"

var _PROPERTIES = ["heading_2d", "heading", "heading_xz", "heading_forward", "heading_xz_forward"]

func _set_target(value):
	if target:
		for prop in _PROPERTIES:
			target.get_meta(prop).value = null
	target = value
	if target:
		for prop in _PROPERTIES:
			if not target.has_meta(prop):
				target.set_meta(prop, Property.new())

func _notification(what):
	match what:
		NOTIFICATION_DISABLED, NOTIFICATION_ENABLED:
			update_target()
func _unhandled_input(event: InputEvent):
	var input_actions = [move_x_m, move_x_p, move_y_m, move_y_p]
	if input_actions.any(func(a): return event.is_action(a)):
		update_target()
		set_physics_process(heading_2d != Vector2.ZERO)
		get_viewport().set_input_as_handled()
func update_target():
	if is_inside_tree() and target:
		for prop in _PROPERTIES:
			target.get_meta(prop).value = get(prop)

var heading_2d: Vector2:
	get:
		return Input.get_vector(move_x_m, move_x_p, move_y_m, move_y_p).limit_length() if can_process() else Vector2.ZERO
var heading: Vector3:
	get:
		return controller.camera.global_basis * Vector3(heading_2d.x, 0, heading_2d.y)
var heading_forward: Vector3:
	get:
		return controller.camera.global_basis * Vector3.FORWARD
var heading_xz: Vector3:
	get:
		return Vector3(heading_2d.x, 0, heading_2d.y).rotated(Vector3.UP, controller.camera.global_rotation.y)
var heading_xz_forward: Vector3:
	get:
		return Vector3.FORWARD.rotated(Vector3.UP, controller.camera.global_rotation.y)
func _physics_process(_delta):
	update_target()
