class_name DashAction extends CharacterBody3DComponent

@export var velocity_profile: Curve
@export var duration: float = 0.3

func _ready():
	set_physics_process(false)
	_connect_user_signal("dash", initialize_dash, [{"name": "direction", "type": TYPE_VECTOR3}])

var _dash_direction: Vector3 = Vector3.FORWARD
var _elapsed: float

func initialize_dash(direction: Vector3):
	if not is_physics_processing():
		_body.floor_snap_length *= 10.0
		_dash_direction = direction
		_elapsed = 0.0
		set_physics_process(true)
		
func _physics_process(delta):
	_body.velocity = _dash_direction * velocity_profile.sample(_elapsed / duration)
	_elapsed += delta
	if _elapsed > duration:
		set_physics_process(false)
		_body.floor_snap_length /= 10.0
		
