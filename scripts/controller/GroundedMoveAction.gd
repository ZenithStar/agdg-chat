class_name GroundedMoveAction extends CharacterBody3DComponent

@export var ground_velocity_max: float = 3.0
var _last_error: Vector3 = Vector3.ZERO
var _raw_heading_prop: Property
var _ground_vel_prop: Property
func _ready():
	if not get_parent().has_meta("heading_xz"):
		get_parent().set_meta("heading_xz", Property.new())
	if not get_parent().has_meta("current_ground_velocity"):
		get_parent().set_meta("current_ground_velocity", Property.new())
	_raw_heading_prop = get_parent().get_meta("heading_xz")
	_ground_vel_prop = get_parent().get_meta("current_ground_velocity")
	_connect_user_signal("floor_entered", _on_floor_entered, [{ "name": "velocity", "type": TYPE_FLOAT }])
	_connect_user_signal("floor_exited", _on_floor_exited, [{ "name": "velocity", "type": TYPE_FLOAT }])
func _on_floor_entered( _velocity ):
	set_physics_process(true)
func _on_floor_exited( _velocity ):
	set_physics_process(false)
func _physics_process(delta):
	var heading = _raw_heading_prop.value if _raw_heading_prop.value else Vector3.ZERO
	var setpoint = heading * ground_velocity_max
	_ground_vel_prop.value = _body.get_real_velocity()
	_ground_vel_prop.value.y = 0
	var error = setpoint - _ground_vel_prop.value
	_body.velocity += error * ground_velocity_max * delta
	_last_error = error
