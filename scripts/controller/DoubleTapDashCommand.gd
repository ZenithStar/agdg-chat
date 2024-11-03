class_name DoubleTapDashCommand extends ControllerComponent

@export var move_x_m: String = "move_left"
@export var move_x_p: String = "move_right"
@export var move_y_m: String = "move_forward"
@export var move_y_p: String = "move_back"
@export var double_tap_threshold_ms: int = 500

var DASH_DIRECTIONS: Array[Vector3] = [Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]

func _set_target(value):
		target = value
		if target:
			if not target.has_user_signal("dash"):
				target.add_user_signal("dash", [{"name": "direction", "type": TYPE_VECTOR3}])

@onready var _last_pressed: Array[int] = [0,0,0,0]
func _unhandled_input(event: InputEvent):
	var input_actions = [move_x_m, move_x_p, move_y_m, move_y_p]
	if target and event.is_pressed() and not event.is_echo():
		for i in 4:
			if Input.is_action_just_pressed(input_actions[i]):
				var now = Time.get_ticks_msec()
				if now - _last_pressed[i] < double_tap_threshold_ms:
					target.emit_signal("dash", DASH_DIRECTIONS[i].rotated(Vector3.UP, controller.camera.global_rotation.y))
				_last_pressed[i] = now
		
