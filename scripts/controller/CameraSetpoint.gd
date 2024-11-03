class_name CameraSetpoint extends Node3D

@export var camera_parameters: CameraParameters

@export_group("Damping", "damping_")
@export var damping_duration: float = 0.1 ## Approximate time it takes to reach the setpoint. Set to 0 for no damping
@export var damping_linear_velocity: float = 0.0001 ## Approximate squared velocity m/s

var push_to: Array[Camera3D] = []

func _ready() -> void:
	top_level = true
	add_to_group("CameraSetpoint")
	set_notify_transform(true)

func _physics_process(delta: float) -> void:
	advance(delta)

func advance(delta: float) -> void:
	var weight: float = move_toward( clamp(delta / damping_duration, 0.0, 1.0), 1.0, delta * damping_linear_velocity / get_parent().global_position.distance_squared_to(global_position) )
	global_transform = global_transform.interpolate_with( get_parent().global_transform, weight )

func apply_to(camera: Camera3D, other: CameraSetpoint = null, weight: float = 0.0):
	if other:
		camera.global_transform = global_transform.interpolate_with(other.global_transform, weight)
	else:
		camera.global_transform = global_transform

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TRANSFORM_CHANGED:
			for camera in push_to:
				apply_to(camera)
				
