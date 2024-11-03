class_name GroundedJumpAction extends CharacterBody3DComponent

@export var initial_velocity: float = 4.0
@export var hold_duration: float = 1.0
@export var hold_acceleration_curve: Curve
@export var coyote_time_duration: float = 0.1
@export var input_buffer_duration: float = 0.1

var _hold_boost_remaining: float = 0.0
#var _coyote_time: float = 0.0
var _boost_direction: float = 1.0

var last_floor_position : Vector3
var since_left_floor : Timer

func _ready():
	set_physics_process(false)
	_connect_user_signal("jump_begin", _on_jump_begin)
	_connect_user_signal("jump_end", _on_jump_end)
	_connect_user_signal("floor_entered", _on_floor_entered, [{ "name": "velocity", "type": TYPE_FLOAT }])
	_connect_user_signal("floor_exited", _on_floor_exited, [{ "name": "velocity", "type": TYPE_FLOAT }])
	since_left_floor = Timer.new()
	since_left_floor.name="CoyoteTimeTimer"
	since_left_floor.autostart=false
	add_child(since_left_floor)
	last_floor_position = _body.global_position
	
func _on_jump_begin():
	var jump:bool=false
	if _body.is_on_floor() and not is_physics_processing():
		jump=true
	else:
		if not since_left_floor.paused and since_left_floor.time_left > 0.:
			jump=true
			_body.global_position.y = last_floor_position.y
	if jump:
		_body.velocity.y += initial_velocity
		_hold_boost_remaining = hold_duration
		_boost_direction = 1.0
		set_physics_process(true)

func _on_jump_end():
	_boost_direction = -1.0
func _on_floor_entered( _velocity ):
	set_physics_process(false)
func _on_floor_exited( _velocity ):
	last_floor_position = ($".." as Node3D).global_position
	since_left_floor.one_shot=true
	if since_left_floor.paused:
		since_left_floor.set_pause(false)
	since_left_floor.start(coyote_time_duration)
	pass
func _physics_process(delta):
	if _hold_boost_remaining:
		_body.velocity.y += hold_acceleration_curve.sample(_hold_boost_remaining / hold_duration) * delta * _boost_direction
		_hold_boost_remaining = move_toward(_hold_boost_remaining, 0.0, delta)
	else:
		set_physics_process(false)
