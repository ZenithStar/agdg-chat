class_name OrbitCamera extends SpringArm3D

@export var joy_rot_sensitivity:float = PI
@export var mouse_sensitivity:float = 0.002
@export var pitch_clamp:float = 0.0
@export var h_offset: float = 0.0
@export var v_offset: float = 0.0

@export var always_capture: bool = false:
	set(value):
		always_capture = value
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if always_capture else \
		(Input.MOUSE_MODE_CAPTURED if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) else Input.MOUSE_MODE_VISIBLE)

var _remote_anchor: RemoteTransform3D
var _anchor: Node3D
var _pivot: Node3D

func _init() -> void:
	_remote_anchor = RemoteTransform3D.new()
	_remote_anchor.name = name+"RemoteAnchor"
	_remote_anchor.update_rotation = false
	_remote_anchor.update_scale = false
	
	_anchor = Node3D.new()
	_anchor.name = name+"Anchor"
	_anchor.top_level = true
	
	_pivot = Node3D.new()
	_pivot.name = name+"Pivot"
	
	add_sibling.call_deferred(_anchor)
	_anchor.add_child.call_deferred(_pivot)
	reparent.call_deferred(_pivot, false)
	_set_remote_anchor_path.call_deferred()
	
func _set_remote_anchor_path()->void:
	_remote_anchor.remote_path = _anchor.get_path()
	

func _ready():
	set_physics_process(Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") != Vector2.ZERO)
	
func _notification(what):
	match what:
		NOTIFICATION_DISABLED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		NOTIFICATION_ENABLED:
			configure()
	
func configure():
	if is_inside_tree() and can_process() and always_capture:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func rotate_camera(input: Vector2):
	var frame_pitch = Quaternion(Vector3.LEFT, input.y )
	var frame_yaw =  Quaternion(Vector3.DOWN, input.x)
	var transformed_up_vec: Vector3 = (_pivot.quaternion * frame_pitch) * Vector3.UP
	if transformed_up_vec.y < pitch_clamp:
		_pivot.quaternion = frame_yaw * _pivot.quaternion
	else:
		_pivot.quaternion = frame_yaw * _pivot.quaternion * frame_pitch
		
func simulate_move_forward_action(pressed=true):
	var event = InputEventAction.new()
	event.action = "move_forward"
	event.pressed = pressed
	event.strength = 1.0 if pressed else 0.0
	Input.action_press("move_forward", event.strength)
	Input.parse_input_event(event)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
					simulate_move_forward_action(event.pressed)
			MOUSE_BUTTON_RIGHT:
				if not always_capture:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE
				if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
					simulate_move_forward_action(event.pressed)
	elif event is InputEventJoypadMotion:
		set_physics_process(Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") != Vector2.ZERO)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			var mouse_rot = event.relative * mouse_sensitivity
			rotate_camera(mouse_rot)
			get_viewport().set_input_as_handled()

func _physics_process(delta):
	var joy_rot = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") * joy_rot_sensitivity * delta
	rotate_camera(joy_rot)
